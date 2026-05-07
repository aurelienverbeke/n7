#include <n7OS/paging.h>
#include <stddef.h> // nécessaire pour NULL
#include <n7OS/kheap.h>
#include <string.h>
#include <n7OS/mem.h>
#include <n7OS/processor_structs.h>

PageDir pageDir;
extern uint32_t placement_address;

/**
 * @brief Récupère l'entrée de table de page et la table de page associée à une adresse
 * 
 * @param addr Adresse
 * @param table Si spécifié (!=NULL), donne la table de page associée
 * @param pte Si spécifié (!=NULL), donne l'entrée de table de page associée sous forme de pointeur
 */
void getPTPTEFromAddress(uint32_t addr, PageTable* _table, PTE** pte) {
    uint16_t directory_index;
    PDE directory_entry;
    PageTable table;
    uint16_t table_index;

    // get pages directory and table indexes
    directory_index = addr >> 22;
    table_index = (addr & 0x3FF000) >> 12;

    // get directory entry
    directory_entry = pageDir[directory_index];

    // get page table base address
    table = (PageTable)(directory_entry.value & 0xFFFFF000);
    if (_table) {
        *_table = table;
    }

    if (pte) {
        *pte = table+table_index;
    }
}

void initialise_paging() {
    // Initialiser le pointeur de placement d'adresse
    kmalloc_init();
    
    // initialiser le gestionnaire de mémoire physique
    init_mem();

    // créer le répertoire de pages
    pageDir = (PageDir) kmalloc_a(PAGE_DIR_ENTRIES_NB*sizeof(PDE));
    memset(pageDir, 0, PAGE_DIR_ENTRIES_NB*sizeof(PDE));

    // créer les tables de pages
    for(uint16_t i=0 ; i<PAGE_DIR_ENTRIES_NB ; i++) {
    //for(uint16_t i=0 ; i<1000 ; i++) {
        PageTable pageTable = (PageTable) kmalloc_a(PAGE_TABLE_ENTRIES_NB*sizeof(PTE));
        memset(pageTable, 0, PAGE_TABLE_ENTRIES_NB*sizeof(PTE));
        pageDir[i].value = ((uint32_t)pageTable) | 0b11; // activer la présence en mémoire et la lecture / écriture
    }

    // mapper toutes les pages déjà utilisées
    for(uint32_t addr=0 ; addr<placement_address ; addr+=PAGE_SIZE) {
    //for(uint32_t addr=0 ; addr<0x100000 ; addr+=PAGE_SIZE) {
        alloc_page_entry(addr, 1, 1);
    }

    setup_base((int)pageDir);

    // charger l'adresse du répertoire de pages dans CR3
    __asm__ __volatile__("mov %0, %%cr3" :: "r"(pageDir));

    /* POUR DEBUG
    for(uint16_t i=0 ; i<100 ; i++) {
        PTE entry;
        entry = ((PageTable)(pageDir[0].page_entry.page << 12))[i];
        printf("%u : %x | ", i, entry.page_entry.page);
    }
    */

    // activer le paging dans CR0
    uint32_t cr0;
    __asm__ __volatile__("mov %%cr0, %0" : "=r"(cr0));
    cr0 = cr0 | 0x80000000;
    __asm__ __volatile__ ("mov %0, %%cr0" : : "r" (cr0));
}

PageTable alloc_page_entry(uint32_t address, int is_writeable, int is_kernel) {
    PageTable table;
    PTE* pte;

    getPTPTEFromAddress(address, &table, &pte);

    pte->page_entry.present = 1;
    pte->page_entry.write = is_writeable;
    pte->page_entry.user = ~is_kernel;
    pte->page_entry.dirty = 0;
    pte->page_entry.accessed = 0;
    pte->page_entry.page = findfreePage() >> 12;

    return table;
}