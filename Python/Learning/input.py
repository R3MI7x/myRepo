persona =  {
    "nome": "Luca",
    "cognome": "Rossi",
    "età": 25

}

if ():
    pass
operazioni = ("aggiungere", "modificare", "eliminare", "terminare")

def start():
    operazione = input("cosa vuoi fare?").strip()
    if operazione.lower() == operazioni [0]:
        x = input("aggiungi chiave valore separati da una virgola ").strip()  
        aggiungi(x.split(",")) 

    elif operazione.lower() == operazioni [1]:
         x = input("aggiungi chiave valore separati da una virgola ").strip()  
         aggiungi(x.split(",")) 

    elif operazione.lower() == operazioni [2]:
        x = input("inserire la chiave da eliminare ")
        elimina(x)

    elif operazione.lower() == operazioni [3]:
        termina()

def aggiungi(x):
    if len(x) == 2:
        persona.update({x[0]: x[1]})
        print(persona)

    elif len(x) < 2:
        print("Inserimento non corretto")
        exit()
    elif len(x) > 2:
        i = 1
        my_dict = x[1:]
        persona.update({x[0]:my_dict})
        print(persona)
            

def elimina(x):
    persona.pop(x)
    print(persona)

def termina():
    print("terminato da utente! ")
    exit()

    
while True:
    start()

