import socket

target_host = "127.0.0.1"
target_port = 9998

# creo l'oggetto socket
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# connetto il clietn
client.connect((target_host, target_port))

# Invio dei dati
client.send(b"GET / HTTP/1.1\r\nHost: google.com\r\n\r\n")


# Ricevo dei dati
response= client.recv(4096)

print(response.decode())
client.close

