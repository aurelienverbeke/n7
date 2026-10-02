# Summary

## Exercise 1

#### Question 1

The problem is schedulable.

The worst case execution times for respectively $T_1$ and $T_2$ are 4 and 2.

#### Question 2

It is fully schedulable regarding any priority order:

- If $P_1 > P_2$, $T_1$ will run at 0 and 5, $T_2$ at 2
- If $P_1 < P_2$, $T_1$ will run at 2 and 5, $T_2$ at 0

## Exercise 2

#### Question 1

Schedulable with Rate Monotonic.

#### Question 2

Schedulable with Deadline Monotonic.

#### Question 3

Not schedulable with Deadline Monotonic.

Schedulable with EDF.

## Exercise 3

Schedulable with Least Laxity First  
Worst case response times of $T_1$ and $T_2$: 5 and 7  
Number of preemptions: 15  
Number of context switches: 29

Schedulable with EDF  
Worst case response times of $T_1$ and $T_2$: 5 and 7  
Number of preemptions: 1 $\rightarrow$ better  
Number of context switches: 17 $\rightarrow$ better

## Exercise 4

#### Question 1

For Preemptive Rate Monotonic:  
Worst case response times of $T_1$ and $T_2$: 1 and 5  
Number of preemptions: 1 $\rightarrow$ better  
Number of context switches: 4 $\rightarrow$ better

For Non-Preemptive Rate Monotonic:  
Worst case response times of $T_1$ and $T_2$: 1 and 5  
Number of preemptions: 0 $\rightarrow$ better  
Number of context switches: 2 $\rightarrow$ better

But works because $WCET(T_1)$ equals 1.

#### Question 2

For Preemptive Rate Monotonic:  
Worst case response times of $T_1$ and $T_2$: 2 and 9  
Number of preemptions: 2 $\rightarrow$ better  
Number of context switches: 5 $\rightarrow$ better

For Non-Preemptive Rate Monotonic: **non schedulable ($T_1$ miss its second deadline)**  
Worst case response times of $T_1$ and $T_2$: **4** and 5  
Number of preemptions: 0 $\rightarrow$ better  
Number of context switches: 2 $\rightarrow$ better

Non-preemption blocks the (now longer) execution of $T_1$.

## Exercise 5

#### Question 1

Not schedulable, $T_6$ misses its deadline.

$r*$: 0, 2, 2, 2, 2, 0  
$D*$: 10, 8, 8, 8, 8, 15

#### Question 2

Schedulable.

$r*$: 0, 2, 3, 5, 5, 0  
$d*$: 7, 7, 9, 10, 10, 15