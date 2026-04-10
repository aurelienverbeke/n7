#include <n7OS/mem.h>
#include <string.h>

uint32_t free_pages_bitmap[GROUPS_NB];

/**
 * @brief Obtenir le numéro de page,
 * le numéro de groupe de page (puisque stockées par 8 dans la bitmap),
 * et le numéro de la page dans le groupe de page (0<=...<=7)
 * 
 * @param addr Adresse à partir de laquelle extraire les indices
 * @param page_id Numéro de page
 * @param page_group_id Numéro de groupe de page
 * @param page_id_in_group Numéro de la page dans le groupe de page
 */
void get_page_indexes_from_address(uint32_t addr, uint32_t* page_id, uint32_t* page_group_id, uint8_t* page_id_in_group) {
    *page_id = addr/PAGE_SIZE;
    *page_group_id = *page_id/GROUPS_SIZE;
    *page_id_in_group = *page_id%GROUPS_SIZE;
}

/**
 * @brief Marque la page allouée
 * 
 * Lorsque la page a été choisie, cette fonction permet de la marquer allouée
 * 
 * @param addr Adresse de la page à allouer
 */
void setPage(uint32_t addr) {
    uint32_t page_id, page_group_id;
    uint8_t page_id_in_group;

    get_page_indexes_from_address(addr, &page_id, &page_group_id, &page_id_in_group);
    free_pages_bitmap[page_group_id] = free_pages_bitmap[page_group_id] | (1<<page_id_in_group);
}

/**
 * @brief Désalloue la page
 * 
 * Libère la page allouée.
 * 
 * @param addr Adresse de la page à libérer
 */
void clearPage(uint32_t addr) {
    uint32_t page_id, page_group_id;
    uint8_t page_id_in_group;
    
    get_page_indexes_from_address(addr, &page_id, &page_group_id, &page_id_in_group);
    free_pages_bitmap[page_group_id] = free_pages_bitmap[page_group_id] & (~(1<<page_id_in_group));
}

/**
 * @brief Fourni la première page libre de la mémoire physique tout en l'allouant
 * 
 * @return uint32_t Adresse de la page sélectionnée
 */
uint32_t findfreePage() {
    uint32_t address = 0;

    for(uint16_t group_id=0 ; group_id<GROUPS_NB ; group_id++) {
        for(uint8_t page_id_in_group=0 ; page_id_in_group<GROUPS_SIZE ; page_id_in_group++) {
            if(!((free_pages_bitmap[group_id] >> page_id_in_group)&0x1)) {
                address = (group_id * GROUPS_SIZE + page_id_in_group) * PAGE_SIZE;
                setPage(address);
                return address;
            }
        }
    }
    
    return 0;
}

/**
 * @brief Initialise le gestionnaire de mémoire physique
 * 
 */
void init_mem() {
    // Initialiser la bitmap des pages disponibles
    memset(free_pages_bitmap, 0, GROUPS_NB*sizeof(uint32_t));
}

/**
 * @brief Affiche l'état de la mémoire physique
 * 
 */
void print_mem() {
    for(uint16_t group_id=0 ; group_id<0x10 ; group_id++) {
        for(uint8_t page_id_in_group=0 ; page_id_in_group<GROUPS_SIZE ; page_id_in_group++) {
            printf("%u : %u | ", group_id*8+page_id_in_group, (free_pages_bitmap[group_id] >> page_id_in_group)&0x1);
        }
        printf("\n");
    }
}