require 'rails_helper'

RSpec.describe SlaEvent, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:applied_sla) }
    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:sla_policy) }
    it { is_expected.to belong_to(:inbox) }
  end

  describe 'push_event_data' do
    it 'returns the correct hash' do
      sla_event = create(:sla_event)
      expect(sla_event.push_event_data).to eq(
        {
          id: sla_event.id,
          event_type: 'frt',
          meta: sla_event.meta,
          created_at: sla_event.created_at.to_i,
          updated_at: sla_event.updated_at.to_i
        }
      )
    end
  end

  describe 'validates_factory' do
    it 'creates valid sla event object' do
      sla_event = create(:sla_event)
      expect(sla_event.event_type).to eq 'frt'
    end
  end

  describe 'backfilling ids' do
    it 'automatically backfills account_id, inbox_id, and sla_id upon creation' do
      sla_event = create(:sla_event)

      expect(sla_event.account_id).to eq sla_event.conversation.account_id
      expect(sla_event.inbox_id).to eq sla_event.conversation.inbox_id
      expect(sla_event.sla_policy_id).to eq sla_event.applied_sla.sla_policy_id
    end
  end
end
