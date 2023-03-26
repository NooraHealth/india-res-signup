class SeedHaryanaValuesForQrCodes < ActiveRecord::Migration[5.2]
  def change

    # Creating 4 different QR codes with identifiers to make sure we are able to track
    # each QR code individually
    qr1 = QrCode.new(name: "QR1",
                         link_encoded: "https://wa.me/919606558333?text=Hi%20from%20QR1",
                         state_id: State.id_for("Haryana"),
                         noora_program_id: NooraProgram.id_for(:mch),
                         text_identifier: "hi_from_qr1")
    qr1.save

    qr2 = QrCode.new(name: "QR2",
                     link_encoded: "https://wa.me/919606558333?text=Hi%20from%20QR2",
                     state_id: State.id_for("Haryana"),
                     noora_program_id: NooraProgram.id_for(:mch),
                     text_identifier: "hi_from_qr2")
    qr2.save

    qr3 = QrCode.new(name: "QR3",
                     link_encoded: "https://wa.me/919606558333?text=Hi%20from%20QR3",
                     state_id: State.id_for("Haryana"),
                     noora_program_id: NooraProgram.id_for(:mch),
                     text_identifier: "hi_from_qr3")
    qr3.save

    qr4 = QrCode.new(name: "QR4",
                     link_encoded: "https://wa.me/919606558333?text=Hi%20from%20QR4",
                     state_id: State.id_for("Haryana"),
                     noora_program_id: NooraProgram.id_for(:mch),
                     text_identifier: "hi_from_qr4")
    qr4.save
  end
end
