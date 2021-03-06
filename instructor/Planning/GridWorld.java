/**
 * Simple grid world Value Iteration.
 * By Michael Madden, Nov 2011.
 *
 * 
 * This code is may be used freely without restriction,
 * though attribution of my authorship would be appreciated.
 *
 *
 * Explanation of the program:
 *
 *   Initialise R to -3 for non-terminal states, -100/+100 for the two terminal states, and 0 for the blocked state.
 *   Initialise V' for all states to 0
 *   Repeat until convergence:
 *       V = V'
 *       Loop over all states:
 *           In each state s:
 *               V'(s) := R(s) if a terminal state
 *               V'(s) := The Bellman equation otherwise (computed using V(s), not V'(s))
 *
 *   Convergence is achieved when the max difference between V’ and V is less than the specified tolerance. 
 */

public class GridWorld {
	// General settings
	private static double Ra = -3;            // reward in non-terminal states (used to initialise r[][])
	private static double gamma = 1;          // discount factor
	private static double pGood = 0.8;        // probability of taking intended action
	private static double pBad = (1-pGood)/2; // 2 bad actions, split prob between them
	private static int N = 10000;             // max number of iterations of Value Iteration
	private static double deltaMin = 1e-9;    // convergence criterion for iteration

	// Main data structures
	private static double V[][];  // long-term utility
	private static double Vp[][]; // UPrime, used in updates
	private static double R[][];  // instantaneous reward
	private static char  Pi[][];  // policy
	
	private static int rMax = 3, cMax = 4;
	
	public static void main(String[] args) {
		int r,c;
		double delta = 0;

		// policy: initially null
		Pi = new char[rMax][cMax]; 
		
		// initialise V'
		Vp = new double[rMax][cMax]; // row, col
		for (r=0; r<rMax; r++) {
			for (c=0; c<cMax; c++) {
				Vp[r][c] = 0;
			}
		}
		// Don't initialise v: will set V=Vprime in iterations
		V = new double[rMax][cMax];
		
		// initialise R: set everything to Ra and then override the terminal states
		R = new double[rMax][cMax]; // row, col
		for (r=0; r<rMax; r++) {
			for (c=0; c<cMax; c++) {
				R[r][c] = Ra;
			}
		}
		R[0][3] =  100;  // positive sink state
		R[1][3] = -100;  // negative sink state
		R[1][1] =    0;  // unreachable state
		
		
		// Now perform Value Iteration.
		int n = 0;
		do {
			// Simultaneous updates: set V = Vp, then compute changes in Vp using prev value of V.
			duplicate(Vp, V); // src, dest
			n++;
			delta = 0;
			for (r=0; r<rMax; r++) {
				for (c=0; c<cMax; c++) {
					updateVPrime(r, c);
					double diff = Math.abs(Vp[r][c] - V[r][c]);
					if (diff > delta)
						delta = diff;
				}
			}
		} while (delta > deltaMin && n < N);
		
		// Display final matrix
		System.out.println("After " + n + " iterations:\n");
		for (r=0; r<rMax; r++) {
			for (c=0; c<cMax; c++) {
				System.out.printf("% 6.1f\t", V[r][c]);
			}
			System.out.print("\n");
		}

		// Before displaying the best policy, insert chars in the sinks and the non-moving block
		Pi[0][3] = '+'; Pi[1][3] = '-'; Pi[1][1] = '#';
		
		System.out.println("\nBest policy:\n");
		for (r=0; r<rMax; r++) {
			for (c=0; c<cMax; c++) {
				System.out.print(Pi[r][c] + "   ");
			}
			System.out.print("\n");
		}
	}
	
	public static void updateVPrime(int r, int c) {
		// IMPORTANT: this modifies the value of Vp, using values in V.
		
		double a[] = new double[4]; // 4 actions
	
		// If at a sink state or unreachable state, use that value
		if ((r==0 && c==3) || (r==1 && c==3) || (r==1 && c==1)) {
			Vp[r][c] = R[r][c];
		}
		else {
			a[0] = aNorth(r,c)*pGood + aWest(r,c)*pBad + aEast(r,c)*pBad;
			a[1] = aSouth(r,c)*pGood + aWest(r,c)*pBad + aEast(r,c)*pBad;
			a[2] = aWest(r,c)*pGood + aSouth(r,c)*pBad + aNorth(r,c)*pBad;
			a[3] = aEast(r,c)*pGood + aSouth(r,c)*pBad + aNorth(r,c)*pBad;
			
			int best = maxindex(a);
			
			Vp[r][c] = R[r][c] + gamma * a[best];
			
			// update policy
			// if best==0 Pi[r][c]='N', etc.
			Pi[r][c] = (best==0 ? 'N' : (best==1 ? 'S' : (best==2 ? 'W': 'E')));
		}
	}
	
	public static int maxindex(double a[]) {
		int b=0;
		for (int i=1; i<a.length; i++)
			b = (a[b] > a[i]) ? b : i;
		return b;
	}
	
	public static double aNorth(int r, int c) {
		// can't go north if at row 0 or if in cell (2,1)
		if ((r==0) || (r==2 && c==1))
			return V[r][c];
		return V[r-1][c];
	}

	public static double aSouth(int r, int c) {
		// can't go south if at row 2 or if in cell (0,1)
		if ((r==rMax-1) || (r==0 && c==1))
			return V[r][c];
		return V[r+1][c];
	}

	public static double aWest(int r, int c) {
		// can't go west if at col 0 or if in cell (1,2)
		if ((c==0) || (r==1 && c==2))
			return V[r][c];
		return V[r][c-1];
	}

	public static double aEast(int r, int c) {
		// can't go east if at col 3 or if in cell (1,0)
		if ((c==cMax-1) || (r==1 && c==0))
			return V[r][c];
		return V[r][c+1];
	}
	
	public static void duplicate(double[][]src, double[][]dst) {
		// Copy data from src to dst
		for (int x=0; x<src.length; x++) {
			for (int y=0; y<src[x].length; y++) {
				dst[x][y] = src[x][y];
			}
		}
	}
}     
   
