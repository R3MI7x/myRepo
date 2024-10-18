package alberiPFFS;

//Guarnieri Rafael #7046908
import java.util.ArrayList;
import java.util.LinkedList;

public class run {

	public static void main(String[] args) {
		
		//Creo l'albero e il nodo radice
		AlberoPFFS<Integer> albero = new AlberoPFFS<Integer>();
		NodoPFFS<Integer> radice = albero.aggiungiRadice(1);
		
		//Per semplicità nel raffigurare l'albero nell'immagine del file del progetto
		//Ogni lettera corrisponde al numero in ordine alfabetico A=1, B=2, ecc...
		
		NodoPFFS<Integer> primoFiglioRadice = albero.aggiungiFiglio(radice, 2);
		NodoPFFS<Integer> secondoFiglioRadice = albero.aggiungiFiglio(radice, 3);
		NodoPFFS<Integer> terzoFiglioRadice = albero.aggiungiFiglio(radice, 4);
		
		//Aggiungo due nodi al primo figlio della radice
		NodoPFFS<Integer> nodo1 = albero.aggiungiFiglio(primoFiglioRadice,5);
		NodoPFFS<Integer> nodo2 = albero.aggiungiFiglio(primoFiglioRadice,6);
			
		//Aggiungo 1 nodo al secondo figlio della radice
		NodoPFFS<Integer> nodo3 = albero.aggiungiFiglio(secondoFiglioRadice,7);
		
		//Aggiungo 4 nodi al nodo3
		NodoPFFS<Integer> nodo4 = albero.aggiungiFiglio(nodo3, 8);
		NodoPFFS<Integer> nodo5 = albero.aggiungiFiglio(nodo3, 9);
		NodoPFFS<Integer> nodo6 = albero.aggiungiFiglio(nodo3, 10);
		NodoPFFS<Integer> nodo7 = albero.aggiungiFiglio(nodo3, 11);
		
		//Stampo alcune info dell'albero
		
		ArrayList<Integer> risultatoVisitaInProfondità = albero.visitaInProfondità();
		LinkedList<Integer> risultatoVisitaInAmpiezza = albero.visitaInAmpiezza();
		
		System.out.println("L'albero è: "+ albero.rappresentaAlbero(radice));
		System.out.println("Il grado del nodo radice è: "+albero.grado(radice));
		System.out.println("L'altezza dell'albero è: "+albero.getAltezza());
		System.out.println("Il numero dei nodi dell'albero è: "+albero.getNumNodi());
		System.out.println("Il numero delle foglie dell'albero è: "+albero.getNumFoglie());
		System.out.println("I figli del nodo radice sono: "+ albero.listaElementiFigliNodo(radice));
		System.out.println("La visita in profondità è: "+ risultatoVisitaInProfondità);
		System.out.println("La visita in ampiezza è: "+ risultatoVisitaInAmpiezza);
		System.out.println(albero.getPadre(primoFiglioRadice));
		
		
		//Aggiungo una nuova radice all'albero
		NodoPFFS<Integer> nuovaRadice = albero.aggiungiNuovaRadice(0);
		System.out.println("\n"+"\n");
		
		//Stampo valori dell'albero aggiornato
		System.out.println("L'albero adesso è: "+ albero.rappresentaAlbero(nuovaRadice));
		System.out.println("Il grado del nodo radice è sempre: "+albero.grado(radice));
		System.out.println("L'altezza dell'albero è: "+albero.getAltezza());
		System.out.println("Il nuovo numero dei nodi dell'albero è: "+albero.getNumNodi());
		System.out.println("Il numero delle foglie dell'albero è: "+albero.getNumFoglie());
		System.out.println("I figli del nodo radice sono sempre: "+ albero.listaElementiFigliNodo(radice));
		System.out.println("La nuova visita in profondità è: "+ albero.visitaInProfondità());
		System.out.println("La nuova visita in ampiezza è: "+ albero.visitaInAmpiezza());
		System.out.println(albero.getPadre(radice));
		
	}

}
