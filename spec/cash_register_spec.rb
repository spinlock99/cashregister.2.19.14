$: << '.' << File.join(File.dirname(__FILE__), '..')

require 'cash_register.rb'

describe CashRegister do
  describe '#new' do
    specify { expect { CashRegister.new }.to_not raise_error }
    specify { expect { CashRegister.new([10, 7, 1]) }.to_not raise_error }
  end

  describe '.make_change' do
    subject(:make_change) { cash_register.make_change(amount) }

    describe 'US Coins' do
      let(:cash_register) { CashRegister.new }

      context 'with an integer argument' do
        let(:amount) { 123 }
        specify { expect { make_change }.to_not raise_error }

        it { should be_a Hash }
        it { should eq({'25' => 4, '10' => 2, '5' => 0, '1' => 3}) }

        context '39' do
          let(:amount) { 39 }
          it { should eq({'25' => 1, '10' => 1, '5' => 0, '1' => 4}) }
        end
      end
      context 'with a non-integer argument' do
        let(:amount) { '123' }
        specify { expect { make_change }.to raise_error }
      end
    end

    describe 'Crazy Foreign Coins' do
      let(:cash_register) { CashRegister.new([10,7,1]) }
      let(:amount) { 14 }

      it { should eq({'10' => 0, '7' => 2, '1' => 0}) }
    end
  end
end

describe Change do
  subject(:change) { Change.new([25,10,5,1]) }

  describe '#new' do
    specify { expect { change }.to_not raise_error }
    it { should eq({'25' => 0, '10' => 0, '5' => 0, '1' => 0}) }
  end

  describe '.size' do
    its(:size) { should eq(0) }
    specify { change.merge({'25' => 5, '10' => 2}).size.should eq(7) }
  end

  describe '.value' do
    its(:value) { should eq(0) }
    specify { change.merge({'25' => 5, '10' => 2}).value.should eq(145) }
  end
end
