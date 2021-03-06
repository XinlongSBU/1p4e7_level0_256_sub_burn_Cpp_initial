module actual_burner_module

  use network

  implicit none

contains

  subroutine actual_burner_init()

    use reaclib_rates, only: init_reaclib, net_screening_init
    use table_rates, only: init_tabular
    use integrator_module, only: integrator_init

    implicit none

    call integrator_init()
    
    call init_reaclib()
    call init_tabular()
    call net_screening_init()
    
  end subroutine actual_burner_init


  subroutine actual_burner_finalize
    use reaclib_rates, only: term_reaclib, net_screening_finalize
    use table_rates, only: term_table_meta

    implicit none
    
    call term_reaclib()
    call term_table_meta()
    call net_screening_finalize()
  end subroutine actual_burner_finalize


  subroutine actual_burner(state_in, state_out, dt, time, inlong_state)

    !$acc routine seq

    use amrex_fort_module, only: rt => amrex_real
    use integrator_module, only: integrator
    use burn_type_module, only: burn_t

    implicit none

    type (burn_t),    intent(in   ) :: state_in
    type (burn_t),    intent(inout) :: state_out
    real(kind=rt),    intent(in   ) :: dt, time
    integer, intent (inout) :: inlong_state

    !$gpu

    call integrator(state_in, state_out, dt, time, inlong_state)
  end subroutine actual_burner

end module actual_burner_module
