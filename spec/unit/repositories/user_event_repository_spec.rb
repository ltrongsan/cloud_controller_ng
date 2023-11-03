require 'spec_helper'

module VCAP::CloudController
  module Repositories
    RSpec.describe UserEventRepository do
      let(:request_attrs) { { 'name' => 'new-space' } }
      let(:org) { Organization.make }
      let(:space) { Space.make(organization: org) }
      let(:assigner) { User.make }
      let(:assignee) { User.make(username: 'frank') }
      let(:assigner_email) { 'foo@bar.com' }
      let(:assigner_username) { 'Mr.Foo' }
      let(:request_attrs) { { 'some_key' => 'some_val' } }
      let(:assigner_audit_info) { UserAuditInfo.new(user_email: assigner_email, user_name: assigner_username, user_guid: assigner.guid) }

      describe 'space role events' do
        Roles::SPACE_ROLE_NAMES.each do |role|
          describe "#record_space_#{role}_add" do
            it 'records the event correctly' do
              event = subject.record_space_role_add(space, assignee, "space_#{role}", assigner_audit_info, request_attrs)
              event.reload
              expect(event.space).to eq(space)
              expect(event.type).to eq("audit.user.space_#{role}_add")
              expect(event.actee).to eq(assignee.guid)
              expect(event.actee_type).to eq('user')
              expect(event.actee_name).to eq(assignee.username)
              expect(event.actor).to eq(assigner.guid)
              expect(event.actor_type).to eq('user')
              expect(event.actor_name).to eq(assigner_email)
              expect(event.actor_username).to eq(assigner_username)
              expect(event.metadata).to eq({ 'request' => request_attrs })
            end
          end

          describe "#record_space_#{role}_remove" do
            it 'records the event correctly' do
              event = subject.record_space_role_remove(space, assignee, "space_#{role}", assigner_audit_info, request_attrs)
              event.reload
              expect(event.space).to eq(space)
              expect(event.type).to eq("audit.user.space_#{role}_remove")
              expect(event.actee).to eq(assignee.guid)
              expect(event.actee_type).to eq('user')
              expect(event.actee_name).to eq(assignee.username)
              expect(event.actor).to eq(assigner.guid)
              expect(event.actor_type).to eq('user')
              expect(event.actor_name).to eq(assigner_email)
              expect(event.actor_username).to eq(assigner_username)
              expect(event.metadata).to eq({ 'request' => request_attrs })
            end
          end
        end
      end

      describe 'organization role events' do
        Roles::ORG_ROLE_NAMES.each do |role|
          describe "#record_organization_#{role}_add" do
            it 'records the event correctly' do
              event = subject.record_organization_role_add(org, assignee, "organization_#{role}", assigner_audit_info, request_attrs)
              event.reload
              expect(event.organization_guid).to eq(org.guid)
              expect(event.type).to eq("audit.user.organization_#{role}_add")
              expect(event.actee).to eq(assignee.guid)
              expect(event.actee_type).to eq('user')
              expect(event.actee_name).to eq(assignee.username)
              expect(event.actor).to eq(assigner.guid)
              expect(event.actor_type).to eq('user')
              expect(event.actor_name).to eq(assigner_email)
              expect(event.metadata).to eq({ 'request' => request_attrs })
            end
          end

          describe "#record_organization_#{role}_remove" do
            it 'records the event correctly' do
              event = subject.record_organization_role_remove(org, assignee, "organization_#{role}", assigner_audit_info, request_attrs)
              event.reload
              expect(event.organization_guid).to eq(org.guid)
              expect(event.type).to eq("audit.user.organization_#{role}_remove")
              expect(event.actee).to eq(assignee.guid)
              expect(event.actee_type).to eq('user')
              expect(event.actee_name).to eq(assignee.username)
              expect(event.actor).to eq(assigner.guid)
              expect(event.actor_type).to eq('user')
              expect(event.actor_name).to eq(assigner_email)
              expect(event.metadata).to eq({ 'request' => request_attrs })
            end
          end
        end
      end
    end
  end
end
