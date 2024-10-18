package alberiPFFS;


// Guarnieri Rafael #7046908

public class NodoPFFS <T> {

	private T info;
	private NodoPFFS<T> primoFiglio, fratelloSuccessivo;
	//private NodoPFFS<T> padre;  
	/*è possibile salvare per ogni nodo il riferimento al padre mantenendo la struttura richiesta, così facendo
	 *  in caso di necessita la resituzione di quest'ultimo sarà immediata. In caso di grandi moli di dati però
	 *  avremo un grande quantitativo di memoria occupata per mantenere il riferimento di ogni nodo.
	 *  Se si volesse scommentare tale variabile sarà obbligatorio aggiustare i vari metodi dove necessario.
	 */


	//costruttore
	/*
	 * Non è previsto un costruttore che crea un nodo nullo perchè in questa implementazionesi ritiene non è necessario. Un nodo
	 * in un albero T può essere rappresentato in modo significativo solo quando contiene un'informazione valida.
	 */
	public NodoPFFS (T x){
		this.info = x;
	}


	//METODI ACCESSORI E RISPETTIVI MUTATORI//

	public T getInfo() {
		return info;
	}

	public void setInfo(T info) {
		this.info = info;
	}

	public NodoPFFS<T> getPrimoFiglio(){
		return primoFiglio;
	}

	public void setPrimoFiglio(NodoPFFS<T> nuovoPrimoFiglio) {
		this.primoFiglio=nuovoPrimoFiglio;

	}

	public NodoPFFS<T> getFratelloSuccessivo(){
		return fratelloSuccessivo;
	}

	public void setFratelloSuccessivo(NodoPFFS<T> nuovoFratelloSuccessivo) {
		this.fratelloSuccessivo=nuovoFratelloSuccessivo;

	}


	//////////////////////////////////////////


	//Utile come cast nel main
	public String infoToString() {
		return info.toString();
	}


	//Ridefinisco il metodo toString della classe Object per la stampa (di tipo Stringa) di un nodo.
	public String toString() {
		StringBuffer stringa= new StringBuffer();
		stringa.append("["+ getClass().getName());
		stringa.append(",");
		stringa.append("\n");
		stringa.append("Nodo con info = "+ this.info);
		stringa.append("\n");
		if( this.primoFiglio!=null) {
			stringa.append("Il suo primo figlio è: "+ primoFiglio.getInfo() +"]");
			return stringa.toString();
		}
		else {
			stringa.append("]");
		}
		return stringa.toString();
	}
}

