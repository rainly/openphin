# == Schema Information
#
# Table name: organization_membership_requests
#
#  id              :integer(4)      not null, primary key
#  organization_id :integer(4)      not null
#  user_id         :integer(4)      not null
#  approver_id     :integer(4)
#  requester_id    :integer(4)
#

class OrganizationMembershipRequest < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  belongs_to :approver, :class_name => "User", :foreign_key => "approver_id"
  belongs_to :requester, :class_name => "User", :foreign_key => "requester_id"

  attr_protected :approver_id

  validates_uniqueness_of :user_id, :scope => [:organization_id]

  before_create :set_requester_if_nil
  after_create :auto_approve_if_admin
  
  def approved?
    true if approver
  end

  def approve!(approving_user)
    unless approved? || !approving_user.is_admin?
      organization.group.users << user
      self.approver=approving_user
      self.save
      OrganizationMembershipRequestMailer.deliver_user_notification_of_organization_membership_approval(organization, user, approver) unless user == approver
    end
  end

  def deny!
    self.destroy
  end

  def has_invitation?
    Invitation.find_all_by_organization_id(organization.id).each do |invitation|
      return true unless invitation.invitees.find_by_email(user.email).nil?
    end
    return false
  end

  private
  def set_requester_if_nil
    requester = user if requester.blank?
  end

  def auto_approve_if_admin
    unless requester.nil?
      approver = User.find(requester_id)
      if approver.is_admin?
        approve!(approver)
      end
    end
  end

end

