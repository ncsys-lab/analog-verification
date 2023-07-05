

class UnsignFPType:

    def __init__(self,size,dec):
        self.size = size
        self.dec = dec

class SignFPType:

    def __init__(self,size,dec):
        self.size = size
        self.dec = dec



class SystemVerilogModule:

    def __init__(self,name):
        self.name = name

    def add_input(self,name):
