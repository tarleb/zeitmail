## The following initializes a very basic firewall.  The settings mostly
## mirror the default behavior of the system, while ensuring that only
## expressively allowed ports are accessible.  This is useful in cases where
## changes have unintended side effects like exposing an unsecured service.
## It is just a basic precaution and generally good style.

## The list of services whose ports should remain open.  Everything else is
## closed down.
{%- set services = ['ssh', 'smtp', 'submission'] %}

iptables packages:
  pkg.installed:
    - pkgs:
      - iptables
      - iptables-persistent

{%- for family in ['ipv4', 'ipv6'] %}

## New Chains
TCP {{family}}:
  iptables.chain_present:
    - name: TCP
    - table: filter
    - family: {{ family }}

UDP {{family}}:
  iptables.chain_present:
    - name: UDP
    - table: filter
    - family: {{ family }}

##
## ALLOW DEFAULTS
##

# Always allow connections from the loopback interface (i.e. from localhost)
iptables {{family}} allow localhost:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - table: filter
    - in-interface: lo
    - family: {{ family }}
    - save: True

# Allow related/established sessions
iptables {{family}} allow established:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - table: filter
    - match: conntrack
    - ctstate: RELATED,ESTABLISHED
    - family: {{ family }}
    - save: True

# Drop unexpected packets
iptables {{family}} drop invalid tcp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - proto: tcp
    - match: conntrack
    - ctstate: INVALID
    - family: {{ family }}
    - save: True

# Allow ICMP packets
allow icmp {{family}}:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - table: filter
    - proto: {{ 'icmp' if family == 'ipv4' else 'icmpv6' }}
    - family: {{ family }}
    - save: True

# Handle new packets in protocol specific chain
{% for protocol in ['tcp', 'udp'] %}
handle new {{protocol}} {{family}}:
  iptables.append:
    - chain: INPUT
    - jump: {{ protocol|upper }}
    - table: filter
    - proto: {{ protocol }}
    - match: conntrack
    - ctstate: NEW
    - family: {{ family }}
    - save: True
    - require:
      - iptables: iptables {{family}} allow localhost
      - iptables: {{ protocol|upper }} {{ family }}
{% endfor %}

reject remaining tcp packets {{family}}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: tcp
    - reject-with: tcp-reset
    - family: {{ family }}
    - save: True
    - require:
      - iptables: allow icmp {{family}}
      - iptables: iptables {{family}} allow established
      - iptables: handle new tcp {{ family }}

reject remaining udp packets {{family}}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: udp
    - reject-with: {{ 'icmp-port-unreachable' if family == 'ipv4' else 'icmp6-port-unreachable' }}
    - family: {{ family }}
    - save: True
    - require:
      - iptables: allow icmp {{family}}
      - iptables: iptables {{family}} allow established
      - iptables: handle new udp {{ family }}

reject remaining packets {{family}}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - reject-with: {{ 'icmp-proto-unreachable' if family == 'ipv4' else 'icmp6-adm-prohibited' }}
    - family: {{ family }}
    - save: True
    - require:
      - iptables: iptables {{family}} allow established
      - iptables: allow icmp {{family}}
      - iptables: handle new tcp {{ family }}
      - iptables: handle new udp {{ family }}

##
## SERVICES
##

{%- for service_name in services %}
# Always allow access via SSH
iptables {{family}} allow {{service_name}}:
  iptables.append:
    - chain: TCP
    - jump: ACCEPT
    - table: filter
    - proto: tcp
    - dport: {{ service_name }}
    - family: {{ family }}
    - save: True
    - require:
      - iptables: handle new tcp {{family}}
{%- endfor %}

##
## POLICIES
##

# The FORWARD chain is unused, just drop packets
FORWARD policy {{ family }}:
  iptables.set_policy:
    - chain: FORWARD
    - policy: DROP
    - table: filter
    - family: {{ family }}

OUTPUT policy {{ family }}:
  iptables.set_policy:
    - chain: OUTPUT
    - policy: ACCEPT
    - table: filter
    - family: {{ family }}

INPUT policy {{family}}:
  iptables.set_policy:
    - chain: INPUT
    - policy: DROP
    - table: filter
    - family: {{ family }}
    - require:
      - iptables: iptables {{family}} allow localhost
      - iptables: iptables {{family}} allow established
      - iptables: iptables {{family}} allow ssh
    - save: True
{%- endfor %}
