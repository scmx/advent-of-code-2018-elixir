defmodule Adventofcode.Day16ChronalClassification.Part1Test do
  use Adventofcode.FancyCase

  import Adventofcode.Day16ChronalClassification
  import Adventofcode.Day16ChronalClassification.Part1

  describe "solve/1" do
    # Ignoring the opcode numbers, how many samples in your puzzle input behave
    # like three or more opcodes?
    test_with_puzzle_input do
      assert 570 = puzzle_input() |> solve()
    end
  end
end

defmodule Adventofcode.Day16ChronalClassification.SamplesTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day16ChronalClassification.Samples

  @input """
  Before: [3, 2, 1, 1]
  9 2 1 2
  After:  [3, 2, 2, 1]
  """

  describe "detect_matching_operations/1" do
    test "detect which operation names match the sample" do
      assert [{9, [:addi, :mulr, :seti]}] = detect_matching_operations(@input)
    end
  end

  describe "parse/1" do
    test "parses sample numbers into nested tuple" do
      assert [{{3, 2, 1, 1}, {9, 2, 1, 2}, {3, 2, 2, 1}}] = parse(@input)
    end
  end
end

defmodule Adventofcode.Day16ChronalClassification.ClassificationTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day16ChronalClassification.Classification

  describe "operation_names/0" do
    test "lists operation names as atoms" do
      assert [:addi, :addr, :bani | _] = operation_names()
      assert 16 == operation_names() |> length()
    end
  end

  describe "addr (add register)" do
    test "stores into register C the result of adding register A and register B" do
      assert %{0 => 1, 1 => 2, 2 => 3} = addr(0, 1, 2, %{0 => 1, 1 => 2})
    end
  end

  describe "addi (add immediate)" do
    test "stores into register C the result of adding register A and value B" do
      assert %{0 => 1, 2 => 2} = addi(0, 1, 2, %{0 => 1})
    end
  end

  describe "mulr (multiply register)" do
    test "stores into register C the result of multiplying register A and register B" do
      assert %{0 => 1, 1 => 2, 2 => 2} = mulr(0, 1, 2, %{0 => 1, 1 => 2})
      assert %{0 => 2, 1 => 2, 2 => 4} = mulr(0, 1, 2, %{0 => 2, 1 => 2})
    end
  end

  describe "muli (multiply immediate)" do
    test "stores into register C the result of multiplying register A and value B" do
      assert %{0 => 1, 2 => 1} = muli(0, 1, 2, %{0 => 1})
      assert %{0 => 2, 2 => 4} = muli(0, 2, 2, %{0 => 2})
    end
  end

  describe "banr (bitwise AND register)" do
    test "stores into register C the result of the bitwise AND of register A and register B" do
      assert %{0 => 1, 2 => 0} = banr(0, 1, 2, %{0 => 1, 1 => 2})
      assert %{0 => 2, 1 => 2, 2 => 2} = banr(0, 1, 2, %{0 => 2, 1 => 2})
    end
  end

  describe "bani (bitwise AND immediate)" do
    test "stores into register C the result of the bitwise AND of register A and value B" do
      assert %{0 => 1, 2 => 1} = bani(0, 1, 2, %{0 => 1, 1 => 2})
      assert %{0 => 2, 1 => 2, 2 => 0} = bani(0, 1, 2, %{0 => 2, 1 => 2})
    end
  end

  describe "borr (bitwise OR register)" do
    test "stores into register C the result of the bitwise OR of register A and register B" do
      assert %{0 => 1, 1 => 2, 2 => 3} = borr(0, 1, 2, %{0 => 1, 1 => 2})
      assert %{0 => 2, 1 => 2, 2 => 2} = borr(0, 1, 2, %{0 => 2, 1 => 2})
    end
  end

  describe "bori (bitwise OR immediate)" do
    test "stores into register C the result of the bitwise OR of register A and value B" do
      assert %{0 => 1, 1 => 2, 2 => 1} = bori(0, 1, 2, %{0 => 1, 1 => 2})
      assert %{0 => 2, 1 => 2, 2 => 3} = bori(0, 1, 2, %{0 => 2, 1 => 2})
    end
  end

  describe "setr (set register)" do
    test "copies the contents of register A into register C. (Input B is ignored.)" do
      assert %{0 => 1, 2 => 1} = setr(0, 1, 2, %{0 => 1})
      assert %{0 => 2, 2 => 2} = setr(0, 1, 2, %{0 => 2})
    end
  end

  describe "seti (set immediate)" do
    test "stores value A into register C. (Input B is ignored.)" do
      assert %{2 => 0} = seti(0, 1, 2, %{})
      assert %{2 => 0} = seti(0, 2, 2, %{})
      assert %{2 => 2} = seti(2, 2, 2, %{})
    end
  end

  describe "gtir (greater-than immediate/register)" do
    test "sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0" do
      assert %{1 => 0, 2 => 0} = gtir(0, 1, 2, %{1 => 0})
      assert %{1 => 0, 2 => 1} = gtir(1, 1, 2, %{1 => 0})
      assert %{1 => 0, 2 => 1} = gtir(2, 1, 2, %{1 => 0})
    end
  end

  describe "gtri (greater-than register/immediate)" do
    test "sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0" do
      assert %{0 => 0, 2 => 0} = gtri(0, 1, 2, %{0 => 0})
      assert %{0 => 1, 2 => 0} = gtri(0, 1, 2, %{0 => 1})
      assert %{0 => 2, 2 => 1} = gtri(0, 1, 2, %{0 => 2})
    end
  end

  describe "gtrr (greater-than register/register)" do
    test "sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0" do
      assert %{0 => 1, 1 => 2, 2 => 0} = gtrr(0, 1, 2, %{0 => 1, 1 => 2})
      assert %{0 => 1, 1 => 1, 2 => 0} = gtrr(0, 1, 2, %{0 => 1, 1 => 1})
      assert %{0 => 2, 2 => 1, 2 => 1} = gtrr(0, 1, 2, %{0 => 2, 1 => 1})
    end
  end

  describe "eqir (equal immediate/register)" do
    test "sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0" do
      assert %{1 => 2, 2 => 0} = eqir(0, 1, 2, %{1 => 2})
      assert %{1 => 1, 2 => 0} = eqir(0, 1, 2, %{1 => 1})
      assert %{1 => 0, 2 => 1} = eqir(0, 1, 2, %{1 => 0})
    end
  end

  describe "eqri (equal register/immediate)" do
    test "sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0" do
      assert %{0 => 2, 2 => 0} = eqri(0, 1, 2, %{0 => 2})
      assert %{0 => 1, 2 => 1} = eqri(0, 1, 2, %{0 => 1})
      assert %{0 => 0, 2 => 0} = eqri(0, 1, 2, %{0 => 0})
    end
  end

  describe "eqrr (equal register/register)" do
    test "sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0" do
      assert %{0 => 1, 1 => 0, 2 => 0} = eqrr(0, 1, 2, %{0 => 1, 1 => 0})
      assert %{0 => 1, 1 => 1, 2 => 1} = eqrr(0, 1, 2, %{0 => 1, 1 => 1})
      assert %{0 => 0, 1 => 1, 2 => 0} = eqrr(0, 1, 2, %{0 => 0, 1 => 1})
      assert %{0 => 0, 1 => 0, 2 => 1} = eqrr(0, 1, 2, %{0 => 0, 1 => 0})
    end
  end
end
