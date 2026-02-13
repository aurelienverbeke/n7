import storm.Schedulers.Scheduler;
import java.util.*;
import storm.*;
import storm.Processors.*;
import storm.Tasks.*;


public class my_RR_Scheduler extends Scheduler {

    class ReadyList extends LinkedList implements Comparator {
	
		public int compare(Object obj0, Object obj1) {
			Task t0= (Task) obj0;
			Task t1= (Task) obj1;

			int d0= 0;
			int d1= 0;

			if (d1>d0) return -1;
			else if (d1 == d0) return 0;
			else return 1;
		}
    }
    
    private ReadyList list_ready;
    private Boolean todo = false;
    private int quantum;
	private int cnt;
    
    public void init() {
		list_ready = new ReadyList();
		quantum = this.getOwnFieldIntValue("quantum");
		cnt = quantum-1;
		todo = true;
    }
	
    public void onActivate(EvtContext c) {
 		list_ready.addLast(c.getCible());
    }
    
    public void onUnBlock(EvtContext c){
		list_ready.addLast(c.getSource());
    }
    
    public void onBlock(EvtContext c){
		list_ready.remove(c.getCible());
    }
    
    public void onTerminated(EvtContext c){
		list_ready.remove(c.getCible());
    }

    public void onTick() {
		if (cnt > 0) {
			todo = false;
			cnt--;
		} else {
			cnt = quantum-1;
			todo = true;
		}
    }
    
    public void sched(){
		if (todo) {
			select();
			todo = false;
		}
    }
    
    public void select() {
		Collections.sort(list_ready, list_ready);

		ArrayList CPUS = this.Kernel.getTasksListeManager().getProcessors();
		Processor p = (Processor) CPUS.get(0);

		if (!p.isRunning()) {
			if (list_ready.size() > 0) {
				Task t = (Task) list_ready.get(0);
				t.runningOn(p);
			}
		} else {
			Task runningTask = p.getrunning();
			runningTask.preempt();
			list_ready.remove(runningTask);
			list_ready.addLast(runningTask);
			Task t = (Task) list_ready.get(0);
			t.runningOn(p);
		}
    }
}