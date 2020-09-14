ActiveSupport.on_load :active_record do
  require "active_record/fixtures"

  module FixtureFileHelpers
    def attachment(fixture_set_name, label, column_type: :integer)
      identifier = ActiveRecord::FixtureSet.identify(label, column_type)
      model_name = ActiveRecord::FixtureSet.default_fixture_model_name(fixture_set_name)
      uri = URI::GID.build(app: GlobalID.app, model_name: model_name, model_id: identifier)
      signed_global_id = SignedGlobalID.new(uri, for: ActionText::Attachable::LOCATOR_NAME)

      %(<action-text-attachment sgid="#{signed_global_id}"></action-text-attachment>)
    end
  end
  ActiveRecord::FixtureSet.context_class.include FixtureFileHelpers
end
