import re

class ANSI():
    # CSI CODES
    @staticmethod
    def CHA(x=1): return ANSI.CSI() + "G" + x
    @staticmethod
    def CSI(): return "\x1B"
    
    # COLORS
    @staticmethod
    def CYAN(): return ANSI.CSI() + "[36m"
    @staticmethod
    def GREEN(): return ANSI.CSI() + "[32m"
    @staticmethod
    def RESET(): return ANSI.CSI() + "[0m"
    @staticmethod
    def WHITE(): return ANSI.CSI() + "[37m"
    
    @staticmethod
    def format(text):
        for match in re.findall('<(\w+)(?::(\w+))?>', text):
            text = text.replace('<%s>' % match[0], getattr(ANSI, match[0])())
        return text

def format(text): return ANSI.format(text)
    