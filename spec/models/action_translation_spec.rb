require "rails_helper"

RSpec.describe "Human Action Translation" do

  describe "translated" do
    where(:action, :successful, :result) do
      [
        [:updated, true, "User aggiornato correttamente."], # default
        [:destroyed, true, "Congratulazioni, hai cancellato l'utente."], # override
        [:updated, false, "Qualcosa è andata storta e non siamo riusciti a salvare il l'utente."], # override
      ]
    end

    with_them do

      subject {
        User.human_action_message(action:, successful:)
      }

      it "should " do
        is_expected.to eq result
      end
    end
  end

  it "in case of custom default" do
    a = Post.human_action_message(action: :updated, successful: true, default: "Aggiornato correttamente.")
    expect(a).to eq "Aggiornato correttamente."
  end

end
