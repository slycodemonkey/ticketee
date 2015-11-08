require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
    let(:user) { FactoryGirl.create(:user) }
    let(:project) { Project.create!(name: "Ticketee", description: "Test Description") }
    let(:state) { State.create!(name: "Hacked") }
    let!(:defaultState) { State.create!(name: "Default State", default: true) }

    let(:ticket) do
        project.tickets.create(title: "State transitions",
                               description: "Can't be hacked.",
                               author: user)
    end

    before :each do
        assign_role!(user, :editor, project)
        sign_in user
    end

    it "cannot transition a state by passing through state_id" do
        expect(ticket.state).to eq(defaultState)

        post :create, { comment: { text: "Did I hack it ??",
                                   state_id: state.id },
                        ticket_id: ticket.id }

        ticket.reload

        expect(ticket.state).to eq(defaultState)
    end
end
