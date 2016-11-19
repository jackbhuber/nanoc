describe Nanoc::Int::OutdatednessChecker do
  let(:outdatedness_checker) do
    described_class.new(
      site: site,
      checksum_store: checksum_store,
      dependency_store: dependency_store,
      rule_memory_store: rule_memory_store,
      action_provider: action_provider,
      reps: reps,
    )
  end

  let(:site) { double(:site) }
  let(:checksum_store) { double(:checksum_store) }
  let(:dependency_store) { double(:dependency_store) }

  let(:rule_memory_store) do
    Nanoc::Int::RuleMemoryStore.new.tap do |store|
      store[item_rep] = old_memory_for_item_rep.serialize
    end
  end

  let(:old_memory_for_item_rep) do
    Nanoc::Int::RuleMemory.new(item_rep).tap do |mem|
      mem.add_filter(:erb, {})
    end
  end

  let(:new_memory_for_item_rep) { old_memory_for_item_rep }

  let(:action_provider) { double(:action_provider) }

  let(:reps) do
    Nanoc::Int::ItemRepRepo.new.tap do |repo|
      repo << item_rep
    end
  end

  let(:item_rep) { Nanoc::Int::ItemRep.new(item, :default) }
  let(:item) { Nanoc::Int::Item.new('stuff', {}, '/foo.md') }

  before do
    allow(action_provider).to receive(:memory_for).with(item_rep).and_return(new_memory_for_item_rep)
  end

  describe '#basic_outdatedness_reason_for' do
    subject { outdatedness_checker.send(:basic_outdatedness_reason_for, obj) }

    context 'with item' do
      let(:obj) { item }

      context 'rule memory differs' do
        let(:new_memory_for_item_rep) do
          Nanoc::Int::RuleMemory.new(item_rep).tap do |mem|
            mem.add_filter(:super_erb, {})
          end
        end

        it 'is outdated due to rule differences' do
          expect(subject).to eql(Nanoc::Int::OutdatednessReasons::RulesModified)
        end
      end

      # …
    end

    context 'with item rep' do
      let(:obj) { item_rep }

      context 'rule memory differs' do
        let(:new_memory_for_item_rep) do
          Nanoc::Int::RuleMemory.new(item_rep).tap do |mem|
            mem.add_filter(:super_erb, {})
          end
        end

        it 'is outdated due to rule differences' do
          expect(subject).to eql(Nanoc::Int::OutdatednessReasons::RulesModified)
        end
      end

      # …
    end

    context 'with layout' do
      # …
    end
  end
end