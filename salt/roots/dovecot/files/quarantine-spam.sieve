require ["fileinto", "comparator-i;ascii-numeric", "relational", "spamtest"];
if spamtest :value "eq" :comparator "i;ascii-numeric" "10"
{
    fileinto "Junk";
}
