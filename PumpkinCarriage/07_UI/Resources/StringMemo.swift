// StringMemo.swift

// MARK: - RoleApplication (ra)
// Source: RoleApplication.swift
//
// RoleApplicationStatus.displayName
// "ra.status.approved" = "Approved"
// "ra.status.rejected" = "Rejected"
// "ra.status.initial" = "Initial"
// "ra.status.pending" = "Pending"
// "ra.status.archived" = "Archived"
//
// RoleApplicationStatus.description
// "ra.statusDesc.approved" = "Application is approved."
// "ra.statusDesc.rejected" = "Application Rejected."
// "ra.statusDesc.initial" = "Application yet submitted."
// "ra.statusDesc.pending" = "Application is pending for review."
// "ra.statusDesc.archived" = "Archived."
//
// EvidenceReviewStatus.displayName
// "ra.evidence.verified" = "Verified"
// "ra.evidence.submitted" = "Submitted"
// "ra.evidence.initial" = "Initial"
// "ra.evidence.rejected" = "Rejected"



// MARK: - TermsVersion (tv)
// Source: TermsVersion.swift
//
// pk_vendor_activation_001 (vendorActivation)
// "tv.vendorActivation.001.c1" = "This listing is for information purposes only and does not imply endorsement, partnership, or guarantee unless separately agreed."
// "tv.vendorActivation.001.c2" = "You confirm you have the necessary rights/permissions to submitted text, logos, and images (including copyright and portrait rights where applicable)."
// "tv.vendorActivation.001.c3" = "You allow us to reproduce, display, translate (e.g., for Japanese users), and make minimal edits (e.g., formatting/cropping) to the provided content solely to operate the service."
// "tv.vendorActivation.001.c4" = "If you provide contact details (email/phone), you consent to display them to signed-in users. We recommend using a business contact."
// "tv.vendorActivation.001.c5" = "You may request correction, hiding, or withdrawal at any time. We will stop public display within a reasonable period (e.g., 7–14 days)."
// "tv.vendorActivation.001.c6" = "Your data may be stored and processed via cloud services (e.g., Google/Firebase), and may be processed outside your country depending on infrastructure."
// "tv.vendorActivation.001.c7" = "We may hide or reject any content that are illegal, misleading, or infringe third-party rights, or that violate platform policies."
//
// pk_vendor_hide_001 (vendorHide)
// "tv.vendorHide.001.c1" = "This will hide your vendor from customers."
// "tv.vendorHide.001.c2" = "You can still manage your vendor from your vendor portal."
// "tv.vendorHide.001.c3" = "However, if you wish to show your vendor to customers again, you will have to resubmit application and receive approval from admin."
//
// pk_vendor_archive_001 (vendorArchive)
// "tv.vendorArchive.001.c1" = "This will stop public display of your vendor and remove it from your vendor portal list."
// "tv.vendorArchive.001.c2" = "For security, compliance, and backup purposes, some data may be retained for a limited period (e.g., up to 30 days) before deletion or anonymization."
// "tv.vendorArchive.001.c3" = "After archiving, restoration may be limited. If you need to restore, please contact support as soon as possible."



// MARK: - VendorStatusApplication (vsa)
// Source: VendorStatusApplication.swift
//
// VendorStatusApplicationEventType.displayName
// "vsa.event.submitted" = "Submitted"
// "vsa.event.resubmitted" = "Resubmitted"
// "vsa.event.approved" = "Approved"
// "vsa.event.rejected" = "Rejected"
// "vsa.event.statusApplied" = "Status Applied"
//
// VendorStatusRequestType.displayName
// "vsa.request.activate" = "Activate"
// "vsa.request.hide" = "Hide"
// "vsa.request.archive" = "Archive"
//
// VendorStatusDecision.displayName
// "vsa.decision.pending" = "Pending"
// "vsa.decision.approved" = "Approved"
// "vsa.decision.rejected" = "Rejected"
//
// StatusRequestAction.title
// "vsa.action.apply.title" = "Apply for Activation"
// "vsa.action.resubmit.title" = "Resubmit for Review"
// "vsa.action.hide.title" = "Request to Hide"
// "vsa.action.archive.title" = "Request to Delete"
//
// StatusRequestAction.primaryButtonTitle
// "vsa.action.apply.primary" = "Submit"
// "vsa.action.resubmit.primary" = "Submit"
// "vsa.action.hide.primary" = "Request"
// "vsa.action.archive.primary" = "Request"



// MARK: - VendorSummary (vs)
// Source: VendorSummary.swift
//
// VendorSummary.placeholder
// "vs.placeholder.loading" = "Loading..."
//
// VendorStatus.displayName
// "vs.status.active" = "Active"
// "vs.status.pending" = "Pending"
// "vs.status.hidden" = "Hidden"
// "vs.status.rejected" = "Rejected"
// "vs.status.archived" = "Archived"
//
// VendorStatus.uiDescription
// "vs.statusDesc.active" = "This vendor is visible to customers."
// "vs.statusDesc.pending" = "Your request is under review. Customers cannot see it yet."
// "vs.statusDesc.rejected" = "The request was rejected. Please review the summary and resubmit."
// "vs.statusDesc.hidden" = "This vendor is hidden from customers."
// "vs.statusDesc.archived" = "This vendor is archived and removed from circulation."
//
// VendorCategory.displayName
// "vs.category.all" = "All"
// "vs.category.studio" = "Studio"
// "vs.category.dress" = "Dress"
// "vs.category.hairMake" = "Hair & Make"
// "vs.category.planner" = "Planner"
// "vs.category.coupleSnap" = "Snap"



// MARK: - ApplyVendorViewModel (avm)
// Source: ApplyVendorViewModel.swift
//
// primaryRegistrationButtonTitle
// "avm.primary.saveContinue" = "Save & Continue"
// "avm.primary.updateContinue" = "Update & Continue"
//
// statusSubtitle
// "avm.statusSubtitle.beforeStart" = "Save registration to start your application."
// "avm.statusSubtitle.initial" = "Complete registration and submit evidence."
// "avm.statusSubtitle.pending" = "We are reviewing your submission."
// "avm.statusSubtitle.approved" = "Approved. You can now use vendor features."
// "avm.statusSubtitle.rejected" = "Please review the rejection reason and resubmit."
// "avm.statusSubtitle.archived" = "This application is archived."
//
// rejectionSummary
// "avm.rejection.fallback" = "Rejected"
//
// errors
// "avm.error.requiredFields" = "Please check the required fields."
// "avm.error.cannotEdit" = "You can’t edit the application in its current status."
// "avm.error.saveFirst" = "Please save the registration information first."
// "avm.error.reviewEvidence" = "Please review your evidence details."
//
// success
// "avm.success.evidenceSubmitted" = "Evidence submitted. Please wait for admin review."
//
// alert
// "avm.alert.defaultTitle" = "Alert"



// MARK: - EditProfileViewModel (epvm)
// Source: EditProfileViewModel.swift
//
// alerts
// "epvm.alert.dupEmail.title" = "Duplicate Email"
// "epvm.alert.dupEmail.msg" = "This email is already in use."
// "epvm.alert.dupUsername.title" = "Duplicate Username"
// "epvm.alert.dupUsername.msg" = "This username is already in use."
// "epvm.alert.error.title" = "Error"
// "epvm.alert.missingBaseline.msg" = "Missing baseline user. Please reopen this screen."
// "epvm.alert.userNotFound.msg" = "User not found. Please try again later."
// "epvm.alert.generic.msg" = "Something went wrong. Please try again later."



// MARK: - LoginViewModel (lvm)
// Source: LoginViewModel.swift
//
// alerts
// "lvm.alert.invalidUsername.title" = "Invalid Username"
// "lvm.alert.invalidUsername.msg" = "Please check username again."
// "lvm.alert.loginFailed.title" = "Failed to Login."
// "lvm.alert.inactiveUser.msg" = "Your account may be inactive or terminated. Please contact support."
// "lvm.alert.invalidPassword.title" = "Invalid Password"
// "lvm.alert.invalidPassword.msg" = "Please check password again."
// "lvm.alert.invalidPassword.hintMsg" = "Please check password again. (Tip: your password may include leading/trailing spaces.)"
// "lvm.alert.unexpected.msg" = "Unexpected error occurred."



// MARK: - RegisterView (rv)
// Source: RegisterView.swift
//
// labels & placeholders
// "rv.label.emailRequired" = "Email *"
// "rv.placeholder.email" = "Email"
// "rv.label.usernameRequired" = "Username *"
// "rv.placeholder.username" = "Username"
// "rv.label.passwordRequired" = "Password *"
//
// buttons & texts
// "rv.button.submit" = "Submit"
// "rv.text.haveAccount" = "Already have an account?"
// "rv.button.login" = "Login"
//
// toast
// "rv.toast.registerSuccess" = "Registration successful."



// MARK: - RegisterReviewView (rrv)
// Source: RegisterReviewView.swift
//
// title
// "rrv.title.reviewDetails" = "Review your details"
//
// fields
// "rrv.field.email" = "Email"
// "rrv.field.username" = "Username"
// "rrv.field.password" = "Password"
//
// buttons
// "rrv.button.edit" = "Edit"
// "rrv.button.register" = "Register"



// MARK: - MainListViewModel (mlvm)
// Source: MainListViewModel.swift
//
// alerts
// "mlvm.alert.error.title" = "Error"
// "mlvm.alert.loadFailed.msg" = "Failed to load vendors. Please try again."



// MARK: - MainViewModel (mvm)
// Source: MainViewModel.swift
//
// alerts
// "mvm.alert.loadFailed.title" = "Failed to load vendors"
// "mvm.alert.loadFailed.msg" = "Please try again."



// MARK: - MarkViewModel (mkvm)
// Source: MarkViewModel.swift
//
// alerts
// "mkvm.alert.loadFailed.title" = "Failed to load marked vendors"
// "mkvm.alert.loadFailed.msg" = "Please try again."



// MARK: - ProfileViewModel (pvm)
// Source: ProfileViewModel.swift
//
// messages
// "pvm.message.error.title" = "Error"
// "pvm.message.loginFirst.msg" = "Please Login First."



// MARK: - ReauthViewModel (rvm)
// Source: ReauthViewModel.swift
//
// alerts
// "rvm.alert.invalidUsername.title" = "Invalid Username"
// "rvm.alert.invalidUsername.msg" = "Please check username again."
// "rvm.alert.loginFailed.title" = "Failed to Login."
// "rvm.alert.inactiveUser.msg" = "Your account may be inactive or terminated. Please contact support."
// "rvm.alert.invalidPassword.title" = "Invalid Password"
// "rvm.alert.invalidPassword.msg" = "Please check password again."
// "rvm.alert.invalidPassword.hintMsg" = "Please check password again. (Tip: your password may include leading/trailing spaces.)"
// "rvm.alert.unexpected.msg" = "Unexpected error occurred."



// MARK: - RegisterViewModel (regvm)
// Source: RegisterViewModel.swift
//
// alerts
// "regvm.alert.dupEmail.title" = "Email already in use"
// "regvm.alert.dupEmail.msg" = "Please use a different email."
// "regvm.alert.dupUsername.title" = "Username already in use"
// "regvm.alert.dupUsername.msg" = "Please use a different username."
// "regvm.alert.registerFailed.title" = "Register failed"
// "regvm.alert.createMarkFailed.title" = "Failed to create mark"
// "regvm.alert.unexpected.msg" = "Unexpected error occurred."



// MARK: - VendorDetailViewModel (vdvm)
// Source: VendorDetailViewModel.swift
//
// messages
// "vdvm.message.warning.title" = "Warning"
// "vdvm.message.refreshSummaryFailed.msg" = "Failed to refresh vendor summary."
// "vdvm.message.loadDetailFailed.msg" = "Failed to load vendor details."
// "vdvm.message.loadImagesFailed.msg" = "Failed to load vendor images."
// "vdvm.message.updateBookmarkFailed.msg" = "Failed to update bookmark."
// "vdvm.message.updateBookmarkCountFailed.msg" = "Bookmark count update failed."
//
// alerts
// "vdvm.alert.error.title" = "Error"
// "vdvm.alert.signInToUseBookmarks.msg" = "Please sign in to use bookmarks."



// MARK: - LoginView (lv)
// Source: LoginView.swift
//
// labels & placeholders
// "lv.label.username" = "Username"
// "lv.placeholder.username" = "username"
// "lv.label.password" = "Password"
//
// buttons
// "lv.button.login" = "Login"
// "lv.button.signUp" = "Sign up"
// "lv.button.guestLogin" = "Login as Guest"
// "lv.button.ok" = "OK"
//
// texts
// "lv.text.noAccount" = "Don't have an account?"
//
// toast
// "lv.toast.signInSuccess" = "Sign in successful."



// MARK: - MainListView (mlv)
// Source: MainListView.swift
//
// filter
// "mlv.filter.label" = "Filter"
// "mlv.filter.reset" = "Reset"
// "mlv.filter.allVendors" = "All vendors"
//
// order
// "mlv.order.label" = "Order"
// "mlv.order.nameAsc" = "Name (A–Z)"
// "mlv.order.nameDesc" = "Name (Z–A)"
// "mlv.order.mostMarked" = "Most Marked"
//
// search
// "mlv.search.prompt" = "Search"



// MARK: - MainView (mv)
// Source: MainView.swift
//
// sections
// "mv.section.category" = "Category"
// "mv.section.popularStores" = "Popular Stores"



// MARK: - MarkView (mkv)
// Source: MarkView.swift
//
// texts
// "mkv.text.signInToUseMarks" = "Please sign in to use Marks."
// "mkv.text.noMarkFound" = "No Mark Found"
// "mkv.text.signInAgainIfIncorrect" = "If this looks incorrect, please sign in again."
//
// alerts
// "mkv.alert.signInRequired.title" = "Sign in required"
//
// buttons
// "mkv.button.ok" = "OK"



// MARK: - ApplyVendorView (av)
// Source: ApplyVendorView.swift
//
// toast
// "av.toast.completeRegistrationFirst" = "Please complete Registration first."
// "av.toast.copied" = "Copied."
//
// common
// "av.button.ok" = "OK"
// "av.text.waitUntilReviewed" = "Please wait until your application is reviewed."
// "av.tab.registration" = "Registration"
// "av.tab.evidence" = "Evidence"
// "av.status.format" = "Status: %@"
// "av.rejectionReason.title" = "Rejection reason"
//
// sections
// "av.section.applicant" = "Applicant"
// "av.section.businessOptional" = "Business (optional)"
// "av.section.confirmations" = "Confirmations"
// "av.section.messageToAdminOptional" = "Message to admin (optional)"
//
// fields
// "av.field.name" = "Name"
// "av.field.role" = "Role"
// "av.field.email" = "Email"
// "av.field.phone" = "Phone"
// "av.field.business" = "Business"
// "av.field.category" = "Category"
//
// placeholders
// "av.placeholder.applicantNameRequired" = "Applicant name (required)"
// "av.placeholder.roleTitleRequired" = "Role / title (required)"
// "av.placeholder.emailOptional" = "Email (optional)"
// "av.placeholder.phoneOptional" = "Phone (optional)"
// "av.placeholder.brandName" = "Brand / Business name"
// "av.placeholder.vendorCategoryExample" = "Vendor Category (e.g.: studio, dress, hair&make, etc.)"
// "av.placeholder.additionalMessage" = "Additional message"
//
// checkboxes
// "av.checkbox.authority" = "I have the authority to represent this business"
// "av.checkbox.rights" = "I have secured the necessary rights (copyright / likeness, etc.) for uploaded materials"
//
// confirmed
// "av.confirmed.format" = "Confirmed: %@"
//
// evidence
// "av.evi.text.completeRegistrationTabFirst" = "Please complete the Registration tab first."
// "av.evi.text.underReviewCannotEdit" = "Your application is under review. (Evidence cannot be edited)"
// "av.evi.section.verificationMethod" = "Verification method"
// "av.evi.method.officialEmail" = "Official Email"
// "av.evi.method.verificationCode" = "Verification Code"
// "av.evi.step1.inputFields" = "Step 1: Input fields"
// "av.evi.step2.sendEmail" = "Step 2: Send Email"
// "av.evi.step2.postCode" = "Step 2: Post code"
// "av.evi.step3.submit" = "Step 3: Submit"
// "av.evi.bullet.useOfficialEmail" = "• Please use email which is shown or used on official links."
// "av.evi.bullet.sendToBelowAddress" = "• Please send email to below address using the email from step 1."
// "av.evi.bullet.copyEmailTitle" = "• For the Email Title, please copy paste below."
// "av.evi.bullet.noEmailBodyNeeded" = "• You do not need to input anything on the email body."
// "av.evi.bullet.urlWhereCodePosted" = "• URL: Please specify URL where the Verification Code will be posted."
// "av.evi.bullet.detailWhereCodePosted" = "• Detail: Please be specific where the code is posted. ( eg. story, profile description, etc. )"
// "av.evi.bullet.postCodeThenSubmit" = "• Post the verification code below on your official channel, then submit."
// "av.evi.bullet.channelsExample" = "• Channels example: Website, Instagram, Youtube, X, etc."
// "av.evi.bullet.removeAfterApproved" = "• You can remove verification code as soon as application is approved."
// "av.evi.text.contactIfNoMethod" = "Please contact us directly if neither of proof method is possible. We are currently working on providing other methods."
// "av.evi.field.url" = "URL"
// "av.evi.field.detail" = "Detail"
// "av.evi.placeholder.emailHintExample" = "pumpkin@*example.com*"
// "av.evi.placeholder.emailLink" = "Link which email is shown or used"
// "av.evi.placeholder.channelUrl" = "Channel URL to post code"
// "av.evi.placeholder.channelDetail" = "Briefly describe where the code is posted"
// "av.evi.label.emailTo" = "Email to"
// "av.evi.value.contactEmail" = "contact@*example.com*"
// "av.evi.label.emailTitle" = "Email Title"
// "av.evi.emailTitle.format" = "[RoleApplication][Email] User:%@ Code:%@"
// "av.evi.label.verificationCode" = "Verification Code"
// "av.evi.button.submitEvidence" = "Submit evidence"



// MARK: - ApplyCurtainView (avc)
// Source: ApplyVendorView.swift
//
// title & text
// "avc.title.becomeVendor" = "Become a Vendor"
// "avc.text.subtitle" = "Complete registration and submit one evidence method so we can verify your official channel."
//
// steps
// "avc.step.registration.title" = "Registration"
// "avc.step.registration.detail" = "Your role and business basics"
// "avc.step.evidence.title" = "Evidence"
// "avc.step.evidence.detail" = "Official email or verification code"
// "avc.step.submit.title" = "Submit"
// "avc.step.submit.detail" = "We will review and notify you"
//
// buttons
// "avc.button.startApplication" = "Start application"
// "avc.button.notNow" = "Not now"
//
// navigation
// "avc.nav.vendorApplication" = "Vendor Application"



// MARK: - EditProfileView (epv)
// Source: EditProfileView.swift
//
// title
// "epv.title.editProfile" = "Edit Profile"
//
// labels & placeholders
// "epv.label.email" = "Email"
// "epv.placeholder.email" = "Email"
// "epv.label.username" = "Username"
// "epv.placeholder.username" = "Username"
// "epv.label.password" = "Password"
//
// buttons
// "epv.button.save" = "Save"
// "epv.button.ok" = "OK"
//
// discard alert
// "epv.discard.title" = "Discard changes?"
// "epv.discard.message" = "You have unsaved changes."
// "epv.discard.discard" = "Discard"
// "epv.discard.cancel" = "Cancel"



// MARK: - FAQView (faqv)
// Source: FAQView.swift
//
// title
// "faqv.title.faqs" = "FAQs"
//
// categories
// "faqv.category.account" = "Account Related"
// "faqv.category.vendor" = "Vendor Related"
// "faqv.category.app" = "App Related"
// "faqv.category.privacy" = "Privacy Related"
// "faqv.category.other" = "Others"
//
// questions
// "faqv.q.account.delete.title" = "How to delete account?"
// "faqv.q.account.delete.body" = "In order to perminentaly delete your account. Please reach out to us via Inquiry tab on the Profile Menu."
// "faqv.q.account.changeUsername.title" = "How can I change username?"
// "faqv.q.account.changeUsername.body" = "In order to change username, plase use the profile update function on Profile Menu."
// "faqv.q.account.changePassword.title" = "How can I change my password?"
// "faqv.q.account.changePassword.body" = "In order to change username, plase use the profile update function on Profile Menu."
// "faqv.q.vendor.contactVendor.title" = "Can I reach out to vendor?"
// "faqv.q.vendor.contactVendor.body" = "We are currently working on a feature that allows you to contact vendors directly. Please wait for more information."
// "faqv.q.vendor.products.title" = "What are products available from vendor?"
// "faqv.q.vendor.products.body" = "In order to support product details, we are negotiating with the vendors. Please stay tuned."
// "faqv.q.vendor.purpose.title" = "What are the purpose of studio, dress, hair&makeup?"
// "faqv.q.vendor.purpose.body" = "In pre-wedding, studio is the photographers, dress is the wedding dress rental service for the photoshoot, and hair & makeup is the stylist helping to prepare for the photoshoot."
// "faqv.q.app.notifications.title" = "How can I set the notification?"
// "faqv.q.app.notifications.body" = "Currently there is no such feature. Please wait for the development."
// "faqv.q.app.deleteInfo.title" = "Is it possible to delete my information by deleting app?"
// "faqv.q.app.deleteInfo.body" = "Please contact us directly via Inquiry tab on the Profile Menu."



// MARK: - NotificationsView (nv)
// Source: NotificationsView.swift
//
// title
// "nv.title.notifications" = "Notifications"
//
// categories
// "nv.category.info" = "[Information]"
// "nv.category.warning" = "[Warning]"
// "nv.category.error" = "[Error]"
// "nv.category.maintenance" = "[Maintenance]"
//
// mock notifications
// "nv.mock.1.title" = "Regarding iOS Update."
// "nv.mock.1.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."
// "nv.mock.2.title" = "Please don't accept any suspicuous calls."
// "nv.mock.2.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."
// "nv.mock.3.title" = "Maintenance planned for 2025.01.01."
// "nv.mock.3.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."
// "nv.mock.4.title" = "aintenance planned for 2025.03.01."
// "nv.mock.4.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."
// "nv.mock.5.title" = "Regarding iOS Update."
// "nv.mock.5.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."



// MARK: - ProfileView (pv)
// Source: ProfileView.swift
//
// sections
// "pv.section.general" = "General"
// "pv.section.help" = "Help"
// "pv.section.vendorMenu" = "Vendor Menu"
// "pv.section.adminMenu" = "Admin Menu"
//
// buttons
// "pv.button.setting" = "Setting"
// "pv.button.notifications" = "Notifications"
// "pv.button.faq" = "FAQ"
// "pv.button.inquiry" = "Inquiry"
// "pv.button.signOut" = "Sign Out"
// "pv.button.signInSignUp" = "Sign In / Sign Up"
// "pv.button.cancel" = "Cancel"
// "pv.button.ok" = "Ok"
// "pv.button.vendorPortal" = "Vendor Portal"
// "pv.button.applyVendor" = "Apply for Vendor"
// "pv.button.adminPortal" = "Admin Portal"
//
// alerts
// "pv.alert.signOut.title" = "Sign Out"
// "pv.alert.signOut.msg" = "Are you sure you want to sign out?"
//
// mail
// "pv.mail.unavailable.title" = "Unable to access Mail app"
// "pv.mail.unavailable.msg" = "Please sign in into your Mail app and try again."
// "pv.inquiry.subject.guest" = "[Guest] Inquiry"
// "pv.inquiry.subject.normal" = "Inquiry"
// "pv.inquiry.body" = "Please provide us as much detail as possible so we can assist you."
//
// user fallbacks
// "pv.user.guest" = "Guest"
// "pv.user.default" = "Mr. Pumpkin"
//
// messages
// "pv.message.accessDenied.title" = "Access Denied"
// "pv.message.accessDenied.vendorOrAdmin.msg" = "Please sign in with a vendor/admin account."
// "pv.message.accessDenied.admin.msg" = "Please sign in with admin account."
// "pv.message.notSignedIn.title" = "Not Signed In"
// "pv.message.notSignedIn.msg" = "Please sign in to access."
// "pv.message.loginFailed.title" = "Login Failed."
// "pv.message.loginFailed.differentUser.msg" = "Please login using the currently signed-in account."
// "pv.message.loginFailed.tryAgain.msg" = "Please try again."



// MARK: - ReauthView (reav)
// Source: ReauthView.swift
//
// labels & placeholders
// "reav.label.username" = "Username"
// "reav.placeholder.username" = "username"
// "reav.label.password" = "Password"
//
// buttons
// "reav.button.login" = "Login"
// "reav.button.ok" = "OK"
//
// texts
// "reav.text.loginAgainToProceed" = "Please login again to proceed"
//
// toast
// "reav.toast.signInAgain" = "Please sign in again."
// "reav.toast.loginFailed" = "Login failed. Please check your username and password."
// "reav.toast.confirmSuccess" = "Confirmation login successful."
// "reav.toast.useCurrentAccount" = "Please login using the currently signed-in account."



// MARK: - SettingView (setv)
// Source: SettingView.swift
//
// titles
// "setv.title.settings" = "Settings"
//
// rows & navigation
// "setv.row.appVersion" = "App Version"
// "setv.nav.terms" = "Terms of Service"
// "setv.nav.privacy" = "Privacy Policy"
// "setv.nav.language" = "Language"
//
// language options
// "setv.lang.systemDefault" = "System Default"
// "setv.lang.ko" = "한국어"
// "setv.lang.en" = "English"
// "setv.lang.ja" = "日本語"



// MARK: - VendorDetailView (vdv)
// Source: VendorDetailView.swift
//
// share
// "vdv.share.checkOutVendor" = "Check out this vendor on PumpkinCarriage."
//
// alerts
// "vdv.alert.openExternal.title" = "Open External Link?"
//
// buttons
// "vdv.button.open" = "Open"
// "vdv.button.cancel" = "Cancel"
// "vdv.button.ok" = "Ok"



// MARK: - VendorManageViewModel (vmanvm)
// Source: VendorManageViewModel.swift
//
// alerts
// "vmanvm.alert.permissionDenied.title" = "Permission denied"
// "vmanvm.alert.permissionDenied.msg" = "Only vendor account can manage vendor. Please Login with Vendor account and try again."
// "vmanvm.alert.error.title" = "Error"
// "vmanvm.alert.accessConfirmFailed.msg" = "Something went wrong with access confirmation. Please try again later."
// "vmanvm.alert.loadFailed.title" = "Failed to load vendors"
// "vmanvm.alert.tryAgain.msg" = "Please try again."



// MARK: - VendorReviewViewModel (vrvm)
// Source: VendorReviewViewModel.swift
//
// messages
// "vrvm.message.warning.title" = "Warning"
// "vrvm.message.refreshSummaryFailed.msg" = "Failed to refresh vendor summary."
// "vrvm.message.loadDetailFailed.msg" = "Failed to load vendor details."
// "vrvm.message.loadImagesFailed.msg" = "Failed to load vendor images."



// MARK: - VendorStatusViewModel (vsvm)
// Source: VendorStatusViewModel.swift
//
// success
// "vsvm.success.requestReceived" = "Request received."
//
// alerts
// "vsvm.alert.permissionDenied.title" = "Permission denied"
// "vsvm.alert.permissionDenied.msg" = "Only vendor can access. Please login and try again."
// "vsvm.alert.error.title" = "Error"
// "vsvm.alert.userContextMissing.msg" = "User context missing. Please login again."
// "vsvm.alert.warning.title" = "Warning"
// "vsvm.alert.refreshSummaryFailed.msg" = "Failed to refresh vendor summary."
// "vsvm.alert.loadDetailFailed.msg" = "Failed to load vendor details."
// "vsvm.alert.duplicatePending.title" = "Request already exists"
// "vsvm.alert.duplicatePending.msg" = "Please wait for previous request to be processed."
// "vsvm.alert.saveFailed.title" = "Save Failed"
// "vsvm.alert.saveFailed.userContextMissing.msg" = "Status request was submitted, but user context is missing. Please try again."
// "vsvm.alert.saveFailed.updateStatusFailed.msg" = "Status request was submitted, but updating vendor status failed. Please try again."
// "vsvm.alert.statusAppNotFound.msg" = "Status application not found."
// "vsvm.alert.submitFailed.msg" = "Failed to submit request."



// MARK: - VendorUpdateViewModel (vuvm)
// Source: VendorUpdateViewModel.swift
//
// alerts
// "vuvm.alert.permissionDenied.title" = "Permission denied"
// "vuvm.alert.permissionDenied.msg" = "Only vendor account can register or manage vendor. Please login with a vendor account and try again."
// "vuvm.alert.loginAgain.msg" = "Please login again."
// "vuvm.alert.error.title" = "Error"
// "vuvm.alert.vendorNotFound.msg" = "Vendor not found or you don't have access."
// "vuvm.alert.vendorDetailNotFound.msg" = "Vendor detail not found. Please try again later."
// "vuvm.alert.loadVendorFailed.msg" = "Failed to load vendor. Please try again later."
// "vuvm.alert.updateNotAllowed.title" = "Update Not Allowed"
// "vuvm.alert.updateNotAllowed.msg" = "Your vendor is in a status that cannot be modified."
// "vuvm.alert.invalidLinkType.title" = "Invalid Link Type"
// "vuvm.alert.invalidLinkType.msg" = "Please select a link type first."
// "vuvm.alert.imageLimit.title" = "Image Limit Reached"
// "vuvm.alert.imageLimit.format" = "You can upload up to %d images."
// "vuvm.alert.noChanges.title" = "No Changes"
// "vuvm.alert.noChanges.msg" = "There is nothing to update."
// "vuvm.alert.sessionInvalid.msg" = "Your session is invalid. Please login again."
// "vuvm.alert.tryAgain.msg" = "Please try again."
//
// validation
// "vuvm.validation.storeName.invalid.title" = "Invalid Store Name"
// "vuvm.validation.storeName.invalid.msg" = "Please enter a store name."
// "vuvm.validation.category.invalid.title" = "Invalid Category"
// "vuvm.validation.category.invalid.msg" = "Please select a valid category."
// "vuvm.validation.country.invalid.title" = "Invalid Country"
// "vuvm.validation.country.invalid.msg" = "Please select a country."
// "vuvm.validation.city.invalid.title" = "Invalid City"
// "vuvm.validation.city.invalid.msg" = "Please select a city."
// "vuvm.validation.district.invalid.title" = "Invalid District"
// "vuvm.validation.district.invalid.msg" = "Please enter a district."
// "vuvm.validation.address.invalid.title" = "Invalid Address Detail"
// "vuvm.validation.address.invalid.msg" = "Please enter at least street or building name."
// "vuvm.validation.language.required.title" = "Language Required"
// "vuvm.validation.language.required.msg" = "Please select at least one supported language."
// "vuvm.validation.description.required.title" = "Description Required"
// "vuvm.validation.description.required.msg" = "Japanese description is mandatory."
// "vuvm.validation.description.tooShort.title" = "Description Too Short"
// "vuvm.validation.description.tooShort.msg" = "Please enter at least 10 characters for the JP description."
//
// success
// "vuvm.success.updated.title" = "Vendor Updated Successfully."
// "vuvm.success.registered.title" = "Vendor Registered Successfully."
// "vuvm.success.registered.msg" = "Please check in 'Manage Vendor' menu."



// MARK: - StatusApplicationView (sav)
// Source: StatusApplicationView.swift
//
// alerts
// "sav.alert.cancel" = "Cancel"
// "sav.alert.confirm" = "Confirm"
//
// buttons
// "sav.button.close" = "Close"
//
// confirmations
// "sav.confirm.hide.format" = "Hide '%@'?"
// "sav.confirm.delete.format" = "Delete '%@'?"
//
// vendor
// "sav.vendorId.format" = "Vendor ID: %@"
//
// terms
// "sav.card.termsAgreement" = "Terms & Agreement"
// "sav.terms.notAvailable" = "Terms not available."
// "sav.consent.agreeProceed" = "I understand the above and agree to proceed."
// "sav.consent.archiveAgree" = "I understand this will stop public display and that data removal may take time."
//
// notes
// "sav.notes.titleOptional" = "Notes (optional)"
// "sav.notes.placeholder" = "Add a short note for the reviewer"
//
// hint
// "sav.hint.submitEnabled" = "Submit/Request is enabled after agreeing to the terms."



// MARK: - VendorGuideView (vgv)
// Source: VendorGuideView.swift
//
// title
// "vgv.title.guideToManagingVendors" = "Guide to Managing Vendors"
//
// categories
// "vgv.category.register" = "Register Vendor"
// "vgv.category.reviewEdit" = "Review / Edit Registered Vendors"
// "vgv.category.changeStatus" = "Change Vendor Status"
//
// guides
// "vgv.guide.register.01" = "Select 'Register Vendor' menu."
// "vgv.guide.register.02" = "Fill in all mandator fields."
// "vgv.guide.register.03" = "Press 'Submit' button."
// "vgv.guide.register.04" = "If nothing went wrong, you will see this success alert."
// "vgv.guide.reviewEdit.01" = "Select 'Vendor Manage' menu."
// "vgv.guide.reviewEdit.02" = "If you tab top part of the Vendor, you can review selected Vendor you have registered."
// "vgv.guide.reviewEdit.03" = "Within the review screen, you can press 'Edit' button to change the information of the Vendor."
// "vgv.guide.reviewEdit.04" = "Once you entered the edit screen, you can modify the information you want."
// "vgv.guide.reviewEdit.05" = "Press 'Save Changes' button to store the information you modified."
// "vgv.guide.changeStatus.01" = "Select 'Vendor Manage' menu."
// "vgv.guide.changeStatus.02" = "Toggle the 'Status' switch to change the status of the Vendor."
// "vgv.guide.changeStatus.03" = "Once you press to change status, an aleart will show. Tab 'OK' to continue."
// "vgv.guide.changeStatus.04" = "If confirmed, your vendor will be changed to 'Active' and be visible to customers."



// MARK: - VendorManageView (vmv)
// Source: VendorManageView.swift
//
// title
// "vmv.title.myVendors" = "My Vendors"
//
// texts
// "vmv.text.noManagedVendors" = "You are not managing any vendors yet."
//
// buttons
// "vmv.button.ok" = "OK"



// MARK: - VendorPortalView (vpv)
// Source: VendorPortalView.swift
//
// title
// "vpv.title.vendorPortal" = "Vendor Portal"
//
// sections
// "vpv.section.accountInfo" = "Account Info"
//
// user
// "vpv.user.format" = "User: %@"
//
// texts
// "vpv.text.manageVendorsHere" = "You can manage your vendors here."
//
// actions
// "vpv.action.register.title" = "Register Vendor"
// "vpv.action.register.subtitle" = "Create a new vendor profile"
// "vpv.action.manage.title" = "Manage Vendor"
// "vpv.action.manage.subtitle" = "Edit store information"
// "vpv.action.guide.title" = "Vendor Guide"
// "vpv.action.guide.subtitle" = "How vendor features work"



// MARK: - VendorReviewView (vrv)
// Source: VendorReviewView.swift
//
// buttons
// "vrv.button.edit" = "Edit"
// "vrv.button.open" = "Open"
// "vrv.button.cancel" = "Cancel"
//
// alerts
// "vrv.alert.openExternal.title" = "Open External Link?"



// MARK: - VendorStatusView (vsv)
// Source: VendorStatusView.swift
//
// title
// "vsv.title.status" = "Status"
//
// buttons
// "vsv.button.ok" = "OK"
//
// sections
// "vsv.section.timeline" = "Timeline"
// "vsv.section.actions" = "Actions"
//
// timeline labels
// "vsv.timeline.created" = "Created"
// "vsv.timeline.updated" = "Updated"
// "vsv.timeline.vendorId" = "Vendor ID"
//
// actions
// "vsv.action.underReview" = "Under Review"
// "vsv.action.applyActivation" = "Apply for Activation"
// "vsv.action.resubmitReview" = "Resubmit for Review"
// "vsv.action.edit" = "Edit"
// "vsv.action.requestHide" = "Request to Hide"
// "vsv.action.requestDelete" = "Request to Delete"
// "vsv.action.contactSupport" = "Contact Support"
//
// rejection summary
// "vsv.reject.title" = "Rejection Summary"
// "vsv.reject.reason" = "Reason"
// "vsv.reject.reasonBody" = "Content requires changes before it can be activated."
// "vsv.reject.notes" = "Notes"
// "vsv.reject.notesBody" = "Please update the vendor info and resubmit for review."
//
// requirements
// "vsv.requirements.title" = "Activation requirements"
// "vsv.requirements.image" = "At least 1 image"
// "vsv.requirements.contact" = "Contact info (email or phone)"
// "vsv.requirements.description" = "Description completed"
// "vsv.requirements.terms" = "Agree to terms"



// MARK: - VendorUpdateView (vuv)
// Source: VendorUpdateView.swift
//
// navigation
// "vuv.nav.back" = "Back"
//
// titles
// "vuv.title.register" = "Register Vendor"
// "vuv.title.update" = "Update Vendor"
//
// submit
// "vuv.submit.submitting" = "Submitting..."
// "vuv.submit.saving" = "Saving..."
// "vuv.submit.submit" = "Submit"
// "vuv.submit.saveChanges" = "Save Changes"
//
// discard
// "vuv.discard.title" = "Discard changes?"
// "vuv.discard.keepEditing" = "Keep Editing"
// "vuv.discard.discard" = "Discard"
// "vuv.discard.message" = "You have unsaved changes. If you go back now, your edits will be lost."
//
// update confirm
// "vuv.updateConfirm.title" = "Update Vendor?"
// "vuv.updateConfirm.message" = "Your vendor will be hidden from customers until approved by admin (Status change request required)."
//
// common buttons
// "vuv.button.ok" = "OK"
// "vuv.button.cancel" = "Cancel"
// "vuv.button.confirm" = "Confirm"
// "vuv.button.add" = "Add"
// "vuv.button.remove" = "Remove"
//
// sections
// "vuv.section.basicInfo" = "Basic Information"
// "vuv.section.location" = "Location"
// "vuv.section.languages" = "Languages"
// "vuv.section.description" = "Description"
// "vuv.section.contactOptional" = "Contact (optional)"
// "vuv.section.externalLinkOptional" = "External Link (optional)"
// "vuv.section.imagesOptional" = "Images (optional)"
//
// fields
// "vuv.field.name" = "Name"
// "vuv.field.category" = "Category"
// "vuv.field.country" = "Country"
// "vuv.field.city" = "City"
// "vuv.field.district" = "District"
// "vuv.field.districtOther" = "District (Other)"
// "vuv.field.street" = "Street"
// "vuv.field.email" = "Email"
// "vuv.field.phone" = "Phone"
// "vuv.field.linkType" = "Type"
//
// placeholders
// "vuv.placeholder.vendorNameEng" = "Vendor Name (Eng)"
// "vuv.placeholder.email" = "Email"
// "vuv.placeholder.phone" = "Phone"
// "vuv.placeholder.linkDetails" = "Details"
// "vuv.placeholder.districtEng" = "Enter district (Eng)"
// "vuv.placeholder.streetEng" = "Address Detail (Eng)"
// "vuv.placeholder.loading" = "Loading"
//
// notices
// "vuv.notice.title" = "Notification"
// "vuv.notice.body" = "If you update vendor details, vendor will be hidden until approved by admin. After updating, please resubmit status reviews."
// "vuv.notice.englishRequired" = "* Name, District (Other), Street must be filled in English."
//
// district
// "vuv.district.manualInput.format" = "%@ (Manual Input)"
//
// links
// "vuv.link.other" = "other"
//
// images
// "vuv.images.none" = "(No images)"
// "vuv.images.main" = "*Main "
// "vuv.images.thumbnailHint" = " will be shown as thumbnail on list."
// "vuv.images.remove.title" = "Remove image?"
// "vuv.images.remove.msg" = "This action cannot be undone."
// "vuv.images.mainLabel" = "Main"
// "vuv.images.setMain" = "Set Main"
//
// drag
// "vuv.drag.move" = "Move"



// MARK: - AdminPortalViewModel (apvm)
// Source: AdminPortalViewModel.swift
//
// alerts
// "apvm.alert.permissionDenied.title" = "Permission denied"
// "apvm.alert.permissionDenied.msg" = "Only admin can acess. Please Login with admin account and try again."



// MARK: - AdminRoleDetailViewModel (ardvm)
// Source: AdminRoleDetailViewModel.swift
//
// templates
// "ardvm.tpl.ownershipAuthority.title" = "Not enough proof of ownership/authority"
// "ardvm.tpl.ownershipAuthority.text" = "We couldn't confirm that you have authority to represent this business."
// "ardvm.tpl.ownershipChannel.title" = "Official channel not verifiable"
// "ardvm.tpl.ownershipChannel.text" = "We couldn't verify the official channel ownership for the provided evidence."
// "ardvm.tpl.identityUnclear.title" = "Applicant identity unclear"
// "ardvm.tpl.identityUnclear.text" = "We couldn't confirm the applicant identity matches the business representative."
// "ardvm.tpl.policyIssue.title" = "Policy-related issue"
// "ardvm.tpl.policyIssue.text" = "Your application does not meet our platform policy requirements."
// "ardvm.tpl.other.title" = "Other"
// "ardvm.tpl.other.text" = "We couldn't approve your application at this time."
//
// alerts
// "ardvm.alert.error.title" = "Error"
// "ardvm.alert.appNotFound.msg" = "Application not found."
// "ardvm.alert.notAllowed.title" = "Not Allowed"
// "ardvm.alert.notAllowed.statusNotUpdatable.msg" = "This application is in status not suitable for update."
// "ardvm.alert.notAllowed.notActionable.msg" = "This application is not actionable."
// "ardvm.alert.missingConfirmations.title" = "Missing Confirmations"
// "ardvm.alert.missingConfirmations.msg" = "Applicant confirmations are incomplete."
// "ardvm.alert.missingEvidence.title" = "Missing Evidence"
// "ardvm.alert.missingEvidence.msg" = "No evidence submitted."
// "ardvm.alert.evidenceNotVerified.title" = "Evidence Not Verified"
// "ardvm.alert.evidenceNotVerified.msg" = "All evidence items must be verified before approval."
// "ardvm.alert.approvedButRoleUpdateFailed.msg" = "Approved, but failed to update user role. Please retry."
// "ardvm.alert.missingTemplate.title" = "Missing Template"
// "ardvm.alert.missingTemplate.msg" = "Please select a rejection template."
// "ardvm.alert.evidenceNotFound.msg" = "Evidence not found."
// "ardvm.alert.adminPermissionRequired.msg" = "Admin permission required."
// "ardvm.alert.invalidSession.title" = "Invalid Session"
// "ardvm.alert.invalidSession.msg" = "Need authentication to review."



// MARK: - AdminRoleViewModel (arvm)
// Source: AdminRoleViewModel.swift
//
// filters
// "arvm.filter.all" = "All"
// "arvm.filter.codePost" = "Code Post"
// "arvm.filter.officialEmail" = "Official Email"



// MARK: - AdminStatusDetailViewModel (asdm)
// Source: AdminStatusDetailViewModel.swift
//
// alerts
// "asdm.alert.permissionDenied.title" = "Permission denied"
// "asdm.alert.permissionDenied.msg" = "Only admin can acess. Please Login with admin account and try again."
// "asdm.alert.warning.title" = "Warning"
// "asdm.alert.refreshSummaryFailed.msg" = "Failed to refresh vendor summary."
// "asdm.alert.loadDetailFailed.msg" = "Failed to load vendor details."
// "asdm.alert.loadImagesFailed.msg" = "Failed to load vendor images."
//
// rejection
// "asdm.rejection.fallback" = "Rejected."
//
// rejection categories
// "asdm.rejectCategory.content" = "Content Issues"
// "asdm.rejectCategory.metadata" = "Listing/Label Issues"
// "asdm.rejectCategory.policy" = "Policy Violations"
// "asdm.rejectCategory.manual" = "#MANUAL INPUT#"
//
// rejection templates (display)
// "asdm.rejectTpl.other" = "Other"
// "asdm.rejectTpl.inappropriateContent" = "Inappropriate / misleading content"
// "asdm.rejectTpl.duplicateListing" = "Duplicate listing"
// "asdm.rejectTpl.invalidContact" = "Invalid contact information"
// "asdm.rejectTpl.rightsUnclear" = "Image/portfolio rights unclear"
// "asdm.rejectTpl.missingRequiredInfo" = "Missing required details"
// "asdm.rejectTpl.policyViolation" = "Policy violation"
// "asdm.rejectTpl.outOfScopeService" = "Out-of-scope service"
// "asdm.rejectTpl.unsupportedRegion" = "Unsupported region"
// "asdm.rejectTpl.cannotVerifyBusiness" = "Cannot verify business legitimacy"
// "asdm.rejectTpl.misleadingInfo" = "Misleading or incorrect information"
// "asdm.rejectTpl.spamOrPromotion" = "Spam or promotional content"
// "asdm.rejectTpl.lowQualityAssets" = "Low-quality media or content"
// "asdm.rejectTpl.languageUnsupported" = "Unsupported language"
// "asdm.rejectTpl.translationIssue" = "Translation issue"
// "asdm.rejectTpl.conflictingOwnershipClaim" = "Conflicting ownership claim"
//
// rejection previews
// "asdm.rejectPreview.inappropriateContent" = "The submitted content appears inappropriate or misleading."
// "asdm.rejectPreview.duplicateListing" = "This vendor appears to be a duplicate of an existing listing."
// "asdm.rejectPreview.invalidContact" = "The provided contact information is invalid or unverifiable."
// "asdm.rejectPreview.rightsUnclear" = "We cannot confirm the rights for the submitted images/portfolio."
// "asdm.rejectPreview.missingRequiredInfo" = "Required information is missing or too vague to review."
// "asdm.rejectPreview.policyViolation" = "This request violates platform policies."
// "asdm.rejectPreview.outOfScopeService" = "The services offered fall outside the supported scope of this platform."
// "asdm.rejectPreview.unsupportedRegion" = "The vendor is located in an unsupported or restricted region."
// "asdm.rejectPreview.cannotVerifyBusiness" = "We were unable to verify the legitimacy of the business."
// "asdm.rejectPreview.misleadingInfo" = "The provided information is misleading, incorrect, or inconsistent."
// "asdm.rejectPreview.spamOrPromotion" = "Submission appears to be spam or excessive promotion."
// "asdm.rejectPreview.lowQualityAssets" = "The media or content quality is too low for platform standards."
// "asdm.rejectPreview.languageUnsupported" = "The submitted language is not supported at this time."
// "asdm.rejectPreview.translationIssue" = "There are translation or localization issues in the content."
// "asdm.rejectPreview.conflictingOwnershipClaim" = "There is a conflicting claim regarding content ownership."



// MARK: - AdminStatusViewModel (asvm)
// Source: AdminStatusViewModel.swift
//
// alerts
// "asvm.alert.permissionDenied.title" = "Permission denied"
// "asvm.alert.permissionDenied.msg" = "Only admin can acess. Please Login with admin account and try again."



// MARK: - AdminVendorDetailViewModel (avdvm)
// Source: AdminVendorDetailViewModel.swift
//
// messages
// "avdvm.message.warning.title" = "Warning"
// "avdvm.message.refreshSummaryFailed.msg" = "Failed to refresh vendor summary."
// "avdvm.message.loadDetailFailed.msg" = "Failed to load vendor details."
// "avdvm.message.loadImagesFailed.msg" = "Failed to load vendor images."
// "avdvm.message.updated.title" = "Updated"
// "avdvm.message.statusChanged.format" = "Vendor status changed to %@."
//
// alerts
// "avdvm.alert.error.title" = "Error"
// "avdvm.alert.sessionExpired.msg" = "Session expired. Please login again."
// "avdvm.alert.permissionDenied.title" = "Permission denied"
// "avdvm.alert.onlyAdminCanChangeStatus.msg" = "Only admin can change vendor status."
// "avdvm.alert.failed.title" = "Failed"
// "avdvm.alert.changeStatusFailed.msg" = "Could not change vendor status."



// MARK: - AdminVendorViewModel (avvm)
// Source: AdminVendorViewModel.swift
//
// alerts
// "avvm.alert.error.title" = "Error"
// "avvm.alert.loadFailed.msg" = "Failed to load vendors. Please try again."



// MARK: - AdminPortalView (apv)
// Source: AdminPortalView.swift
//
// title
// "apv.title.adminPortal" = "Admin Portal"
//
// sections
// "apv.section.accountInfo" = "Account Info"
//
// user
// "apv.user.format" = "User: %@"
// "apv.user.roleApplicationCount" = "Number of role applications: ??"
// "apv.user.pendingVendorCount" = "Number of pending vendors: ??"
//
// actions
// "apv.action.manageVendors.title" = "Manage Vendors"
// "apv.action.manageVendors.subtitle" = "View vendor list"
// "apv.action.reviewRoles.title" = "Review Role Applications"
// "apv.action.reviewRoles.subtitle" = "Approve role applications"
// "apv.action.reviewVendors.title" = "Review Pending Vendors"
// "apv.action.reviewVendors.subtitle" = "Approve pending vendors"
//
// buttons
// "apv.button.ok" = "OK"



// MARK: - AdminRoleDetailView (ardv)
// Source: AdminRoleDetailView.swift
//
// title
// "ardv.title.roleAppDetail" = "Role Application Detail"
//
// sections
// "ardv.section.status" = "Status"
// "ardv.section.applicantDetail" = "Applicant Detail"
// "ardv.section.businessDetail" = "Business Detail"
// "ardv.section.application" = "Application"
// "ardv.section.evidence" = "Evidence"
// "ardv.section.terms" = "Terms"
// "ardv.section.decision" = "Decision"
// "ardv.section.actions" = "Actions"
// "ardv.reject.section.preview" = "Preview"
//
// texts
// "ardv.text.appNotFound" = "Application not found."
// "ardv.text.noActions" = "No actions available for this application."
// "ardv.reject.text.noTemplates" = "No templates available."
// "ardv.reject.text.selectTemplateHint" = "Select a template to preview the rejection message."
//
// fields
// "ardv.field.name" = "Name"
// "ardv.field.roleTitle" = "Role title"
// "ardv.field.email" = "Email"
// "ardv.field.phone" = "Phone"
// "ardv.field.authorityConfirmed" = "Authority confirmed"
// "ardv.field.rightsConfirmed" = "Rights confirmed"
// "ardv.field.brandName" = "Brand Name"
// "ardv.field.category" = "Category"
// "ardv.field.currentRole" = "Current role"
// "ardv.field.requestedRole" = "Requested role"
// "ardv.field.termsVersion" = "Terms version"
// "ardv.field.agreedAt" = "Agreed at"
// "ardv.field.result" = "Result"
// "ardv.field.reviewer" = "Reviewer"
// "ardv.field.decidedAt" = "Decided"
// "ardv.field.rejectionCategory" = "Category"
//
// common buttons
// "ardv.button.cancel" = "Cancel"
// "ardv.button.confirm" = "Confirm"
// "ardv.button.reject" = "Reject"
// "ardv.button.approve" = "Approve"
//
// toasts
// "ardv.toast.needLogin" = "Need login"
// "ardv.toast.copied" = "Copied."
//
// approve/reject sheet
// "ardv.reject.title" = "Reject Role Application"
// "ardv.reject.field.category" = "Category"
// "ardv.reject.field.template" = "Template"
// "ardv.reject.placeholder.detailOptional" = "Add detail (optional)"
// "ardv.approve.title" = "Approve Application"
//
// evidence
// "ardv.evidence.method.officialEmail" = "Official Email"
// "ardv.evidence.method.codePost" = "Code Post"
// "ardv.evidence.submittedAt.format" = "Submitted: %@"
// "ardv.evidence.field.email" = "Email"
// "ardv.evidence.field.url" = "URL"
// "ardv.evidence.field.code" = "Code"
// "ardv.evidence.button.verified" = "Evidence Verified"
// "ardv.evidence.alert.verify.title" = "Verify evidence?"
// "ardv.evidence.alert.verify.msg" = "This will mark the evidence as verified."



// MARK: - AdminRoleView (arv)
// Source: AdminRoleView.swift
//
// navigation
// "arv.nav.title" = "Role Applications"
//
// tabs
// "arv.tab.pending" = "Pending"
// "arv.tab.history" = "History"
//
// header
// "arv.header.subtitle" = "Review vendor role applications"
//
// buttons
// "arv.button.ok" = "OK"
//
// empty
// "arv.empty.pending" = "No pending applications."
// "arv.empty.history" = "No history yet."
// "arv.empty.hint" = "Applications will appear here after a user submits their request."
//
// row
// "arv.row.noBrand" = "(No brand name)"
// "arv.row.applicant.format" = "Applicant: %@"
// "arv.row.method.format" = "Method: %@"
// "arv.row.method.unknown" = "Unknown"



// MARK: - AdminStatusDetailView (asdv)
// Source: AdminStatusDetailView.swift
//
// navigation
// "asdv.nav.title" = "Review"
//
// titles
// "asdv.title.applicationDetail" = "Application Detail"
//
// sections
// "asdv.section.commentFromVendor" = "Comment from Vendor"
// "asdv.section.actions" = "Actions"
//
// fields
// "asdv.field.request" = "Request"
// "asdv.field.decision" = "Decision"
// "asdv.field.vendorId" = "Vendor ID"
// "asdv.field.applicantUserId" = "Applicant User ID"
// "asdv.field.termsVersion" = "Terms Version"
// "asdv.field.agreedAt" = "Agreed At"
// "asdv.field.created" = "Created"
// "asdv.field.updated" = "Updated"
//
// buttons
// "asdv.button.ok" = "OK"
// "asdv.button.cancel" = "Cancel"
// "asdv.button.reject" = "Reject"
// "asdv.button.approve" = "Approve"
// "asdv.button.showReviewScreen" = "Show Review Screen"
//
// texts
// "asdv.text.alreadyDecided.format" = "This application is already %@."
//
// toasts
// "asdv.toast.copiedVendorId" = "Copied VendorID."
// "asdv.toast.copiedUserId" = "Copied UserID."
//
// alerts
// "asdv.alert.invalidPath.title" = "Cannot open this screen"
// "asdv.alert.invalidPath.msg" = "The access path is invalid or required data is missing."
// "asdv.alert.error.title" = "Error"
// "asdv.alert.approveFailed.msg" = "Failed to approve application."
// "asdv.alert.rejectFailed.msg" = "Failed to reject application."
//
// approve/reject sheet
// "asdv.reject.title.format" = "Reject %@ Request"
// "asdv.reject.field.category" = "Category"
// "asdv.reject.field.template" = "Template"
// "asdv.reject.section.preview" = "Preview"
// "asdv.reject.placeholder.detailOptional" = "Add detail (optional)"
// "asdv.reject.hint.appended" = "This note will be appended to the rejection reason."
// "asdv.approve.title.format" = "Approve %@ Request"



// MARK: - AdminStatusView (asv)
// Source: AdminStatusView.swift
//
// navigation
// "asv.nav.title" = "Status Review"
//
// tabs
// "asv.tab.pending" = "Pending"
// "asv.tab.history" = "History"
//
// header
// "asv.header.title" = "Status Applications"
// "asv.header.countPending.format" = "%d pending"
// "asv.header.countHistory.format" = "%d history"
//
// menu
// "asv.menu.requestType" = "Request Type"
// "asv.menu.decision" = "Decision"
// "asv.menu.all" = "All"
//
// buttons
// "asv.button.ok" = "OK"
//
// empty
// "asv.empty.pending.title" = "No pending applications"
// "asv.empty.pending.subtitle" = "This could be a temporary network error. Please try again later."
// "asv.empty.history.title" = "No history"
// "asv.empty.history.subtitle" = "Approved / rejected / cancelled results will show here."
//
// sections
// "asv.section.actionRequired" = "Action Required"
// "asv.section.history" = "History"
//
// filters
// "asv.filter.all" = "All"
//
// row
// "asv.row.vendorId.format" = "Vendor ID: %@"
// "asv.row.applicantId.format" = "Applicant ID: %@"
// "asv.row.terms.format" = "Terms: %@"



// MARK: - AdminVendorDetailView (avdv)
// Source: AdminVendorDetailView.swift
//
// menu
// "avdv.menu.copyVendorId" = "Copy Vendor ID"
// "avdv.menu.changeStatus" = "Change Status"
//
// sections
// "avdv.section.status" = "Status"
//
// buttons
// "avdv.button.cancel" = "Cancel"
// "avdv.button.apply" = "Apply"
// "avdv.button.confirm" = "Confirm"
// "avdv.button.open" = "Open"
// "avdv.button.ok" = "OK"
//
// alerts
// "avdv.alert.confirmChange.title" = "Confirm Change"
// "avdv.alert.confirmChange.format" = "Change '%@' to '%@'?"
// "avdv.alert.openExternal.title" = "Open External Link?"
//
// toasts
// "avdv.toast.copied" = "Copied."



// MARK: - AdminVendorView (avv)
// Source: AdminVendorView.swift
//
// filters
// "avv.filter.status.all" = "All"
//
// search
// "avv.search.prompt" = "Search"
//
// buttons
// "avv.button.ok" = "OK"



// MARK: - HomeView (hv)
// Source: HomeView.swift
//
// titles
// "hv.title.main" = "Pumpkin Carriages"
// "hv.title.marks" = "Marks"
// "hv.title.my" = "My"
// "hv.title.profile" = "Profile"
//
// tabs
// "hv.tab.main" = "Main"
// "hv.tab.marks" = "Marks"
// "hv.tab.my" = "My"
// "hv.tab.profile" = "Profile"
//
// alerts
// "hv.alert.signInRequired.title" = "Sign in required"
// "hv.alert.signInRequired.msg" = "Please sign in to view Marks."
//
// buttons
// "hv.button.ok" = "OK"



// MARK: - RoleApplicationForm (raf)
// Source: RoleApplicationForm.swift
//
// evidence helper
// "raf.evidenceHelper.officialEmail" = "Provide an official email hint and a public URL that shows or uses that email, then send an email to the address below."
// "raf.evidenceHelper.codePost" = "Post the verification code on your official channel (Website, Instagram, Youtube, X, etc.), then submit with the URL and location detail."



// MARK: - Validation (vld)
// Source: Validation.swift
//
// titles
// "vld.title.invalidEmail" = "Invalid Email"
// "vld.title.invalidPassword" = "Invalid Password"
// "vld.title.invalidUsername" = "Invalid Username"
// "vld.title.invalid" = "Invalid."
// "vld.title.invalidInput" = "Invalid Input"
// "vld.title.invalidPhone" = "Invalid Phone Number"
// "vld.title.invalidExternalLink" = "Invalid External Link"
//
// messages
// "vld.msg.requiredFields" = "Please fill in all mandatory fields."
// "vld.msg.emailMin.format" = "Email must be %d characters or more."
// "vld.msg.emailFormat" = "Please enter a valid email address."
// "vld.msg.passwordMin.format" = "Password must be %d characters or more."
// "vld.msg.usernameRange.format" = "Username must be between %d and %d characters."
// "vld.msg.usernameChars" = "Username can only contain letters, numbers, dots (.), underscores (_), and hyphens (-)."
// "vld.msg.loginEmpty" = "Username and password must not be empty."
// "vld.msg.phoneCountryCodeRequired" = "Please select a country code for the phone number."
// "vld.msg.phoneDigitsOnly" = "Please enter digits only (no spaces or symbols)."
// "vld.msg.phoneMinDigits.format" = "Please enter at least %d digits for the phone number."
// "vld.msg.externalLinkFields" = "Please fill in all external link fields or remove empty rows."
// "vld.msg.phoneNumberRequired" = "Please enter a phone number or deselect contry code."
//
// english-only helper
// "vld.englishOnly.title.format" = "Invalid %@"
// "vld.englishOnly.msg.format" = "Please enter %@ in English (Roman alphabet)."



// MARK: - VendorWriteService (vws)
// Source: VendorWriteService.swift
//
// alerts
// "vws.alert.permissionDenied.title" = "Permission denied"
// "vws.alert.error.title" = "Error"
// "vws.alert.imageUploadFailed.title" = "Image Upload Failed"
// "vws.alert.saveFailed.title" = "Save Failed"
// "vws.alert.updateNotAllowed.title" = "Update Not Allowed"
//
// messages
// "vws.alert.tryAgain.msg" = "Please try again."
// "vws.alert.registerOnlyVendorOrAdmin.msg" = "Only vendor or admin can register a vendor."
// "vws.alert.registerSaveFailed.msg" = "Vendor registration failed. Please try again."
// "vws.alert.sessionInvalid.msg" = "Your session is invalid. Please login again."
// "vws.alert.vendorNotFoundForUpdate.msg" = "Vendor not found for update."
// "vws.alert.updateNotAllowed.msg" = "Your vendor is under review or archived. Please try again later."
// "vws.alert.noPermissionToEdit.msg" = "You don't have permission to edit this vendor."
// "vws.alert.updateSaveFailed.msg" = "Vendor update failed. Please try again."
// "vws.alert.updateStatusOnlyVendorOrAdmin.msg" = "Only vendor or admin can update vendor status."
// "vws.alert.vendorNotFound.msg" = "Vendor not found."
// "vws.alert.noPermissionToUpdate.msg" = "You don't have permission to update this vendor."



// MARK: - ImageResourceView (irv)
// Source: ImageResourceView.swift
//
// placeholder
// "irv.placeholder.imageNotFound" = "Image not found"
// "irv.placeholder.failedToLoad" = "Failed to load"



// MARK: - PasswordComponentView (pcv)
// Source: PasswordComponentView.swift
//
// placeholders
// "pcv.placeholder.password" = "Password"



// MARK: - VendorDetailComponentView (vdcv)
// Source: VendorDetailComponentView.swift
//
// toasts
// "vdcv.toast.waitMoment" = "Please wait a moment."
// "vdcv.toast.copied" = "Copied."
// "vdcv.toast.signInToCopy" = "Sign in to copy."
// "vdcv.toast.signInToShare" = "Sign in to share this vendor."
// "vdcv.toast.signInToUseBookmarks" = "Sign in to use bookmarks."
// "vdcv.toast.signInToOpenLinks" = "Sign in to open external links."
//
// sheet
// "vdcv.sheet.introTitle.format" = "Introduction of %@"
//
// alert
// "vdcv.alert.copy.title" = "Copy to clipboard?"
//
// buttons
// "vdcv.button.copy" = "Copy"
// "vdcv.button.cancel" = "Cancel"
// "vdcv.button.seeMore" = "See More"
// "vdcv.button.hide" = "Hide"
// "vdcv.button.reveal" = "Reveal"
//
// labels
// "vdcv.label.category" = "Category: "
// "vdcv.label.languages" = "Languages: "
//
// map
// "vdcv.text.signInToViewMap" = "Please sign in to view map."
//
// sections
// "vdcv.section.contact" = "Contact & External Links"
//
// contact
// "vdcv.contact.email" = "Email"
// "vdcv.contact.phone" = "Phone"
// "vdcv.contact.phoneWithCountry.format" = "Phone (%@)"
//
// accessibility
// "vdcv.a11y.signInRequired" = "Sign in required"
//
// description view defaults
// "vdcv.desc.defaultTitle" = "Description Title"
// "vdcv.desc.defaultBody" = "Description details will go here"



// MARK: - VendorFilterSheetView (vfs)
// Source: VendorFilterSheetView.swift
//
// buttons
// "vfs.button.cancel" = "Cancel"
// "vfs.button.reset" = "Reset"
// "vfs.button.apply" = "Apply"
//
// sections
// "vfs.section.location" = "Location"
// "vfs.section.language" = "Language"
//
// fields
// "vfs.field.country" = "Country"
// "vfs.field.city" = "City"
// "vfs.field.district" = "District"
//
// preview
// "vfs.preview.tapToShow" = "Tap to show filter sheet"

