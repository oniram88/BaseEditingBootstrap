module BaseEditingBootstrap
  RSpec.describe BaseClassFinder do
    where(:controller_path, :result) do
      [
        ["not_found", nil], # no model
        ["user", User], # singular
        ["users", User], # plural
        ["customer/users", User], # with namespaced resource but not model
        ["other/customer/users", User], # with namespaced multilevel resource but not model
        ["posts", Post], # with namespaced resource and model
        ["customer/posts", Customer::Post], # with namespaced resource and model
        ["other/customer/posts", Customer::Post], # with namespaced resource and model
      ]
    end

    with_them do
      let(:instance) { described_class.new(controller_path) }
      subject { instance.model }
      it "should " do
        is_expected.to be == result
      end
    end

  end
end