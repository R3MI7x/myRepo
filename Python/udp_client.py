import socket
target_host = "127.0.0.1"
target_port = 9997

# Creo l'oggetto socket

client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Invio un po' di dati
client.sendto(b"AAAABBBBCCC", (target_host,target_port))

# Ricevo un po' di dati
data, addr = client.recvfrom(4096)

print(data.decode())
client.close()








