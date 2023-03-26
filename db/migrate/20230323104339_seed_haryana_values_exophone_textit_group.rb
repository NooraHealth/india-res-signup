class SeedHaryanaValuesExophoneTextitGroup < ActiveRecord::Migration[5.2]
  def change
    # first creating the Exophone that can detect this number as being the one the user is calling to
    # This helps extract the language, state and program of a user based on their incoming call
    exo = Exophone.new(virtual_number: "18001210095",
                       language_id: Language.id_for(:hindi),
                       state_id: State.id_for("Haryana"),
                       program_id: NooraProgram.id_for(:mch))
    exo.save


    ## Creating textit groups - IVR Neutral, QR Neutral, ANC Neutral, PNC Neutral

    # CCP Haryana IVR Neutral
    haryana_ivr_neutral = TextitGroup.new(name: "CCP Haryana IVR Neutral",
                                          textit_id: "e599e2fe-f745-4bbe-83c3-8aa429e7ff74",
                                          language_id: Language.id_for(:hindi),
                                          state_id: State.id_for("Haryana"),
                                          program_id: NooraProgram.id_for(:mch),
                                          exotel_number: "18001210095",
                                          onboarding_method_id: OnboardingMethod.id_for(:ivr)
                                          )
    haryana_ivr_neutral.save

    # CCP Haryana QR Code Neutral
    haryana_qr_neutral = TextitGroup.new(name: "CCP Haryana QR Code Neutral",
                                          textit_id: "d894cef5-2a60-446c-ac08-e3cc884fba58",
                                          language_id: Language.id_for(:hindi),
                                          state_id: State.id_for("Haryana"),
                                          program_id: NooraProgram.id_for(:mch),
                                          onboarding_method_id: OnboardingMethod.id_for(:qr_code)
                                          )
    haryana_qr_neutral.save

    # CCP Haryana ANC Neutral
    haryana_anc_neutral = TextitGroup.new(name: "CCP Haryana ANC Neutral",
                                          textit_id: "3c2bff6c-719a-46c4-a767-b940a5611fd3",
                                          language_id: Language.id_for(:hindi),
                                          state_id: State.id_for("Haryana"),
                                          program_id: NooraProgram.id_for(:mch),
                                          condition_area_id: ConditionArea.id_for(:anc),
                                          onboarding_method_id: OnboardingMethod.id_for(:ivr)
                                          )
    haryana_anc_neutral.save

    # CCP Haryana PNC Neutral
    haryana_pnc_neutral = TextitGroup.new(name: "CCP Haryana PNC Neutral",
                                          textit_id: "2bd5acea-e5fc-4969-95fb-2458e6cb804e",
                                          language_id: Language.id_for(:hindi),
                                          state_id: State.id_for("Haryana"),
                                          program_id: NooraProgram.id_for(:mch),
                                          condition_area_id: ConditionArea.id_for(:pnc),
                                          onboarding_method_id: OnboardingMethod.id_for(:ivr)
                                          )
    haryana_pnc_neutral.save


  end
end
