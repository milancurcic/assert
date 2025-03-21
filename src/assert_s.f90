!
!     (c) 2019-2020 Guide Star Engineering, LLC
!     This Software was developed for the US Nuclear Regulatory Commission (US NRC) under contract
!     "Multi-Dimensional Physics Implementation into Fuel Analysis under Steady-state and Transients (FAST)",
!     contract # NRC-HQ-60-17-C-0007
!
submodule(assert_m) assert_s
  implicit none

contains

  module procedure assert
    use characterizable_m, only : characterizable_t

    character(len=:), allocatable :: header, trailer

    toggle_assertions: &
    if (enforce_assertions) then

      check_assertion: &
      if (.not. assertion) then

        header = 'Assertion "' // description // '" failed on image ' // string(this_image())

        represent_diagnostics_as_string: &
        if (.not. present(diagnostic_data)) then

          trailer = "foo"

        else

          select type(diagnostic_data)
            type is(character(len=*))
              trailer = diagnostic_data
            type is(complex)
              trailer = string(diagnostic_data)
            type is(integer)
              trailer = string(diagnostic_data)
            type is(logical)
              trailer = string(diagnostic_data)
            type is(real)
              trailer = string(diagnostic_data)
            class is(characterizable_t)
              trailer = diagnostic_data%as_character()
            class default
              trailer = "of unsupported type."
          end select

        end if represent_diagnostics_as_string

        error stop header // ' with diagnostic data "' // trailer // '"'

      end if check_assertion

    end if toggle_assertions
    
  contains
    
    pure function string(numeric) result(number_as_string)
      !! Result is a string represention of the numeric argument
      class(*), intent(in) :: numeric
      integer, parameter :: max_len=128
      character(len=max_len) :: untrimmed_string
      character(len=:), allocatable :: number_as_string

      select type(numeric)
        type is(complex)
          write(untrimmed_string, *) numeric
        type is(integer)
          write(untrimmed_string, *) numeric
        type is(logical)
          write(untrimmed_string, *) numeric
        type is(real)
          write(untrimmed_string, *) numeric
        class default
          error stop "Internal error in subroutine 'assert': unsupported type in function 'string'."
      end select

      number_as_string = trim(adjustl(untrimmed_string))

    end function string
    
  end procedure

end submodule
