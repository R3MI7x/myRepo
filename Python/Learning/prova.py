class macchina:

    def __init__ (self, modello):
        self.modello = modello

    def scan  (self):
        print("i")

    def scan (self, macchina):
        print ("macchina")

macchina = macchina()
macchina.scan(macchina)