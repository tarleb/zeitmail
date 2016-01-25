#!/usr/bin/env python3

import mailbox


class TesterMailbox:
    def __init__(self, path="./mail-mnt/test.mbox", reset=True):
        if reset:
            self.reset(path)
        self.mailbox = mailbox.mbox(path)

    def reset(self, path):
        f = open(path, "w")
        f.truncate()
        f.close()

    def contains_all(self, msgs):
        return all(self.contains_message(msg) for msg in msgs)

    def contains_message(self, needle_msg):
        for msg in self.mailbox:
            if msg["Message-ID"] == needle_msg["Message-ID"]:
                return True
        return False

    def close(self):
        self.mailbox.close()
