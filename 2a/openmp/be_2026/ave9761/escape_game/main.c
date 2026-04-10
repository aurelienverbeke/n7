#include "aux.h"



int main(int argc, char **argv){
  int    i, j, n, nrooms, nplayers, room, player, next_room, finish, old_room;
  int *rooms_list;
  long ts, te;
  
   /* Command line argument */
  if ( argc == 3 ) {
    nrooms    = atoi(argv[1]);    /* the number of rooms */
    nplayers  = atoi(argv[2]);    /* the number of players */
  } else {
    printf("Usage:\n\n ./main nrooms nplayers, nwhere\n");
    printf("nrooms      is the number of rooms\n");
    printf("nplayers    is the number of players\n");
    return 1;
  }

  finish = 0;
  
  init(nplayers, nrooms);
  
  // Setup rooms locks
  omp_lock_t rooms_locks[nrooms];
  for(i=0 ; i<nrooms ; i++)
    omp_init_lock(rooms_locks+i);

  printf("\n==================================================\n");
  printf("The escape game begins\n\n");

  #pragma omp parallel private(player, room, next_room, old_room) num_threads(nplayers)
  {
    player = omp_get_thread_num();
    room = get_my_first_room(player, nrooms);
    printf("Player %2d entering the game from room %2d\n",player,room);
    
    for (;;){
      while(!omp_test_lock(rooms_locks+room)) {
        #pragma atomic compare
        if (finish == 1) {
          break;
        }
      }

      #pragma atomic compare
      if (finish == 1) {
        break;
      }

      next_room = solve_enigma(player, room, nrooms);
      omp_unset_lock(rooms_locks+room);
      
      if(next_room==-999) {
        printf("There was an error!!!  %2d %2d\n",player,room);
        break;
      } else if (next_room==1000){
        /* Found the exit door!!! quit the game*/
        #pragma atomic write
        finish = 1;
        printf("Yahi! Player %2d found the exit door!\n",player);
        break;
      } else {
        room = next_room;
      }
    }

    printf("Player %2d is out!\n",player);
  }

  for(i=0 ; i<nrooms ; i++)
    omp_destroy_lock(rooms_locks+i);

  printf("\n==================================================\n");

  return 0;
}
