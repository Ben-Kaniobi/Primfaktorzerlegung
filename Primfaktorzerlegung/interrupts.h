#ifndef INTERRUPTS_H
#define INTERRUPTS_H


/**
 ******************************************************************************
 * Macro       :_ENABLE_IRQ
 ******************************************************************************
 * \brief   Enable Interrupts (IRQs).
 *
 * This macro clears the I-Bit in the CPSR register
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */
#define _ENABLE_IRQ() asm volatile (\
                        "mrs  r0, cpsr\n"\
                        "bic  r0, r0,#0x00000080\n"\
                        "msr  cpsr, r0"\
                        :/* no outputs */   \
                        :/* no inputs */   \
                        :"r0")  /* clobbered registers */


/**
 ******************************************************************************
 * Macro       :_DISABLE_IRQ
 ******************************************************************************
 * \brief   Disable Interrupts (IRQs).
 *
 * This macro sets the I-Bit in the CPSR register
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */
#define _DISABLE_IRQ() asm volatile (\
                        "mrs  r0, cpsr\n"\
                        "orr  r0, r0,#0x00000080\n"\
                        "msr  cpsr, r0"\
                        :/* no outputs */   \
                        :/* no inputs */   \
                        :"r0")   /* clobbered registers */


/**
 ******************************************************************************
 * Macro       : _ENABLE_FIQ
 ******************************************************************************
 * \brief   Enable Fast-Interrupts (FIQs).
 *
 * This macro clears the F-Bit in the CPSR register
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */
#define _ENABLE_FIQ() asm volatile (\
                            "mrs  r0, cpsr\n"\
                            "bic  r0, r0,#0x00000040\n"\
                            "msr  cpsr, r0"\
                           :/* no outputs */   \
                           :/* no inputs */   \
                           :"r0")   /* clobbered registers */

/**
 ******************************************************************************
 * Macro       : _DISABLE_FIQ
 ******************************************************************************
 * \brief   Disable Fast-Interrupts (FIQs).
 *
 * This macro sets the F-Bit in the CPSR register
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */
#define _DISABLE_FIQ()   asm volatile (\
                            "mrs  r0, cpsr\n"\
                            "orr  r0, r0,#0x00000040\n"\
                            "msr  cpsr, r0"\
                           :/* no outputs */   \
                           :/* no inputs */   \
                           :"r0")   /* clobbered registers */

/**
 ******************************************************************************
 * Macro       : _GET_IRQ_STATE
 ******************************************************************************
 * \brief   returns state of IRQ.
 *
 * This macro reads the I-Bit in the CPSR register
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */

#define _GET_IRQ_STATE() ((_READ_CPSR() & 0x00000080u) != 0)

/**
 ******************************************************************************
 * Macro       : _GET_FIQ_STATE
 ******************************************************************************
 * \brief   returns state of FIRQ.
 *
 * This macro reads the F-Bit in the CPSR register
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */

#define _GET_FIQ_STATE() ((_READ_CPSR() & 0x00000040u) != 0)

/**
 ******************************************************************************
 * function       :READ_CPSR()
 ******************************************************************************
 * \brief   Returns the content of the CPSR regster.
 *
 ******************************************************************************
 * \return    content of the CPSR
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */
static inline unsigned int _READ_CPSR(){
   unsigned int cpsr;
   asm volatile ("mrs  %0, cpsr\n"
         :"=&r" (cpsr)\
         :/* no inputs */);
   return cpsr;
}
/**
 ******************************************************************************
 * function       : WRITE_CPSR(unsigned int cpsr)
 ******************************************************************************
 * \brief   Set the content of the CPSR regster.
 *
 ******************************************************************************
 * \param     cpsr      new content of the CPSR
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */
static inline void _WRITE_CPSR(unsigned int cpsr){
   asm volatile ("msr  cpsr,%0\n"
         :/* no outputs */   \
         :"r" (cpsr));

}

/**
 ******************************************************************************
 * function       : READ_SPSR()
 ******************************************************************************
 * \brief   Returns the content of the SPSR regster.
 *
 ******************************************************************************
 * \return    content of the SPSR
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */
static inline unsigned int _READ_SPSR(){
   unsigned int spsr;
   asm volatile ("mrs  %0, spsr\n"
         :"=&r" (spsr)\
         :/* no inputs */);
   return spsr;
}

/**
 ******************************************************************************
 * function       : WRITE_SPSR(unsigned int spsr)
 ******************************************************************************
 * \brief   Set the content of the SPSR regster.
 *
 ******************************************************************************
 * \param     spsr      new content of the SPSR
 ******************************************************************************
 *  \author     M.Muehlemann
 *  \date       10.05.2007
 ******************************************************************************
 */
static inline void _WRITE_SPSR(unsigned int spsr){
   asm volatile ("msr  spsr,%0\n"
         :/* no outputs */   \
         :"r" (spsr));

}



#endif /*INTERRUPTS_H_*/
