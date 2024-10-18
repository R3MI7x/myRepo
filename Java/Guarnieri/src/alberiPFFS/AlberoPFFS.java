package alberiPFFS;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Stack;

//Guarnieri Rafael #7046908

public class AlberoPFFS <T> {

	private  NodoPFFS<T> radice ;
	private int altezza;
	private int numNodi;
	private int numFoglie;
	//private int nodiEsterni
	/* è possibile salvare per un albero T il numero di nodi esterni in una variabile T ma in questa implementazione non
	 * se ne tiene conto. Si dovrebbe quindi aggiustare i vari metodi dove necessario.
	 */

	//METODI ACCESSORI//

	public NodoPFFS<T> getRadice() {
		return radice;
	}
	public boolean isEmpty() {
		return radice==null;
	}

	public T info(NodoPFFS<T> x) {
		return x.getInfo();
	}

	public int getAltezza() {
		return altezza;
	}

	public int getNumNodi() {
		return numNodi;
	}

	public int getNumFoglie() {
		return numFoglie;
	}


	//////////////|||||||||||||///////////////


	// METODO CHE INSERISCE LA RADICE NELL'ALBERO: PRENDE IN INGRESSO L'INFORMAZIONE E RESTITUISCE UN NODO
	public NodoPFFS<T> aggiungiRadice (T info){
		if (radice!=null) {
			return radice;
		}
		else {
			numNodi=1;
			numFoglie=1;
			radice= new NodoPFFS<T>(info);

			return radice;
		}
	}

	//METODO CHE AGGIUNGE UN NODO U COME FIGLIO DI UN NODO V
	public NodoPFFS<T> aggiungiFiglio(NodoPFFS<T> nodoPadre, T infoNodo){
		if(nodoPadre.getPrimoFiglio()==null) {
			NodoPFFS<T> temp = new NodoPFFS<T>(infoNodo);
			nodoPadre.setPrimoFiglio(temp);
			numNodi++;
			if(livello(temp)>altezza) { 					//controlla il livello: se è maggiore dell'altezza,
				altezza++;     								//allora quest'ultima va incrementata
			}
	//numFoglie rimane invariato (aumenta di 1 e diminuisce di 1)
			
			return temp;
			
		} else {
			NodoPFFS<T> temp = nodoPadre.getPrimoFiglio();
			while(temp.getFratelloSuccessivo()!=null) { 	//ciclo per prendere l'ultimo dei fratelli
				temp = temp.getFratelloSuccessivo();

			}
			NodoPFFS<T> nuovoFiglio = new NodoPFFS<T>(infoNodo);
			temp.setFratelloSuccessivo(nuovoFiglio);
			numNodi++;
			numFoglie++;
	//altezza non varia perchè l'aggiunta viene fatta sempre su lo stesso livello
			
			return nuovoFiglio;
		}													
	}
	
	//METODO PER L'INSERIMENTO DI UNA NUOVA RADICE
	/*con l'aggiunta di una nuova radice aumenta l'altezza e 
	il numero dei nodi ma il numero delle foglie rimane invariato*/
	public NodoPFFS<T> aggiungiNuovaRadice(T info){
		if(radice==null) {
			aggiungiRadice(info);
		} else {
			NodoPFFS<T> nuovaRadice = new NodoPFFS<T> (info);
			nuovaRadice.setPrimoFiglio(radice);
			radice = nuovaRadice;
			numNodi++;
			altezza++;	
		}
		return radice;
	}														

	//METODO CHE RESTITUISCE IL NUMERO DEI FIGLI DI UN NODO: PRENDE IN INGRESSO UN NODO E RESTITUISCE IL NUMERO DEI FIGLI
	public int grado (NodoPFFS<T> x) {
		if(x.getPrimoFiglio()==null) {
			return 0;
		}
		else {
			NodoPFFS<T> temp = x.getPrimoFiglio();
			int grado = 1;
			while(temp.getFratelloSuccessivo()!=null) {
				grado++;
				temp=temp.getFratelloSuccessivo();
			}
			return grado;
		}
	}
	
	//METODO CHE RESTITUISCE IL LIVELLO DI UN NODO: PRENDE IN INGRESSO UN NODO E RESTITUISCE IL VALORE(INTERO) DEL LIVELLO DEL NODO
	/* Sarebbe possibile creare una variabile nella classe nodo per salvare il livello di ogni nodo e restituirlo senza costi. 
	 * Si è preferito però mantenere poco spazio in memoria per mantenere coerente la scelta fatta con la variabile padre 
	 */
	public int livello(NodoPFFS<T> x) {
		if (radice == null) {  
			System.out.println("L'albero è vuoto! "); 
			return -1;  									//Albero è vuoto quindi restituisco un valore negativo
		}

	// Inizializzo una coda per la visita in ampiezza
		LinkedList<NodoPFFS<T>> coda  = new LinkedList<>();
		coda.add(radice);

		int livelloCorrente = 0;  							// Inizializza il livello corrente a 0
		while (!coda.isEmpty()) {  
			int totaleNodiCorrenti = coda.size(); 			// Ottiene il numero di nodi nel livello corrente

			for (int i = 0; i < totaleNodiCorrenti; i++) {  // Itera attraverso tutti i nodi nel livello corrente
				NodoPFFS<T> nodoCorrente = coda.remove();

				if (nodoCorrente.equals(x)) {
					return livelloCorrente;  				// Il Nodo in questione è stato trovato, restituisce il livello corrente
				}

	// Aggiungo i figli alla coda
				NodoPFFS<T> figlioCorrente = nodoCorrente.getPrimoFiglio();
				while (figlioCorrente != null) {
					coda.add(figlioCorrente);
					figlioCorrente = figlioCorrente.getFratelloSuccessivo();
				}										
			}											

			livelloCorrente++; 								// Passa al livello successivo
		}
		System.out.println("Nodo non trovato! ");
		return -1;  										// Nodo non trovato restituisco un valore negativo
	}

	//METODO CHE RESTITUISCE LA LISTA DI TIPO<T> DEI VALORI DEI FIGLIO DI UN NODO
	public LinkedList<T> listaElementiFigliNodo(NodoPFFS<T> nodo){
		LinkedList<T> listaElementi = new LinkedList<T>();
		if(nodo.getPrimoFiglio()==null) {
			System.out.println("Nodo non ha figli! ");
			return listaElementi;
		}
	// Aggiungo il primo figlio alla lista
		listaElementi.addLast(nodo.getPrimoFiglio().getInfo());
		NodoPFFS<T> nodoProvvisorio = nodo.getPrimoFiglio();
	
	// Aggiungo i fratelli successivi alla lista
		while(nodoProvvisorio.getFratelloSuccessivo()!=null) {
			listaElementi.addLast(nodoProvvisorio.getFratelloSuccessivo().getInfo());
			nodoProvvisorio=nodoProvvisorio.getFratelloSuccessivo();

		}
		return listaElementi;
	}

	//METODO PER LA VISITA IN PROFONDITÀ
	/*Per questo metodo si utilizza due pile perchè ogni nodo ha solo due puntatori uno al primo figlio e l'altro al fratello 
	 * successivo per questo non è possibile a differenza un albero binario segliere quale nodo inserire (con il metodo push) 
	 * per primo. Por ottenere l'ordine corretto quindi si utilizza una seconda pila che chiamo pilaTemp.
	 * 
	 */
	public ArrayList<T> visitaInProfondità(){
		ArrayList<T> lista = new ArrayList<T>();
		if(radice==null) {
			return lista;
		}
		Stack<NodoPFFS<T>> pila = new Stack<NodoPFFS<T>>();
		pila.push(radice);
		
		while (!pila.isEmpty()) {
			NodoPFFS<T> nodo = pila.pop();
			lista.add(nodo.getInfo());

			NodoPFFS<T> figlio = nodo.getPrimoFiglio();
			Stack<NodoPFFS<T>> pilaTemp = new Stack<NodoPFFS<T>>();
			while(figlio!=null) {
				pilaTemp.push(figlio);
				figlio= figlio.getFratelloSuccessivo();

			}
			while(!pilaTemp.isEmpty()) {					//INVERTO L'ORDINE DELLE INFORMAZIONI
				pila.push(pilaTemp.pop());
			}
		} 

		return lista;
	}

	//METODO PER LA VISITA IN AMPIEZZA: Si utilizza una coda per effettuare la visita in ampiezza
	public LinkedList<T> visitaInAmpiezza(){
		LinkedList<T> lista = new LinkedList<T>();
		if (radice==null) {
			return lista;
		}
		LinkedList<NodoPFFS<T>> coda = new LinkedList<>();
		coda.add(radice);
		while(!coda.isEmpty()) {
			NodoPFFS<T> nodo = coda.remove();
			lista.add(nodo.getInfo());
			NodoPFFS<T> figlio = nodo.getPrimoFiglio();
			while(figlio!=null) {
				coda.add(figlio);
				figlio=figlio.getFratelloSuccessivo();
			}
		}
		return lista;
	}


	//METODO PER RESTITUIRE IL PADRE DI UN NODO SE NON SI POSSIEDE UNA VARIABILE NELLA CLASSE NODO
	/*
	 * Il metodo è stato creato nella classe albero per poter accedere alla variabile radice.
	 * Senza salvare per ogni nodo il riferimento al padre l'unico modo è scorrere tutto l'albero dalla radice
	 */
	public String getPadre(NodoPFFS<T> x){
		if (x==null) {
			System.out.println("Il nodo non esiste! ");
			return null;
		}
		LinkedList<NodoPFFS<T>> coda = new LinkedList<>();
		coda.add(radice);
		while(!coda.isEmpty()) {
			NodoPFFS<T> nodo = coda.remove();
			NodoPFFS<T> figlio = nodo.getPrimoFiglio();
			while(figlio!=null) {
				coda.add(figlio);
				if(figlio==x) {
					return nodo.toString();
				}
				figlio=figlio.getFratelloSuccessivo();
			}
		}
		return null;
	}

	public  String rappresentaAlbero(NodoPFFS<T> radice) {
		if (radice == null) {
			return "albero vuoto";
		}
		StringBuilder risultato = new StringBuilder(radice.getInfo().toString());
		if (radice.getPrimoFiglio() != null) {
			risultato.append("[");
			risultato.append(rappresentaAlbero(radice.getPrimoFiglio()));
			risultato.append("]");
		}

		if (radice.getFratelloSuccessivo() != null) {
			risultato.append(",");
			risultato.append(rappresentaAlbero(radice.getFratelloSuccessivo()));
		}
		return risultato.toString();
	}

}
