
// StringMemoKR.swift

// MARK: - RoleApplication (ra)
// Source: RoleApplication.swift
//
// RoleApplicationStatus.displayName
// "ra.status.approved" = "승인됨"
// "ra.status.rejected" = "거절됨"
// "ra.status.initial" = "초기"
// "ra.status.pending" = "대기 중"
// "ra.status.archived" = "보관됨"
//
// RoleApplicationStatus.description
// "ra.statusDesc.approved" = "신청이 승인되었습니다."
// "ra.statusDesc.rejected" = "신청이 거절되었습니다."
// "ra.statusDesc.initial" = "아직 제출되지 않았습니다."
// "ra.statusDesc.pending" = "신청이 심사 대기 중입니다."
// "ra.statusDesc.archived" = "보관 처리되었습니다."
//
// EvidenceReviewStatus.displayName
// "ra.evidence.verified" = "확인됨"
// "ra.evidence.submitted" = "제출됨"
// "ra.evidence.initial" = "초기"
// "ra.evidence.rejected" = "거절됨"


// MARK: - TermsVersion (tv)
// Source: TermsVersion.swift
//
// pk_vendor_activation_001 (vendorActivation)
// "tv.vendorActivation.001.c1" = "이 등록은 정보 제공 목적이며, 별도의 합의가 없는 한 보증, 제휴, 파트너십 또는 추천을 의미하지 않습니다."
// "tv.vendorActivation.001.c2" = "제출한 텍스트, 로고, 이미지(해당 시 저작권 및 초상권 포함)에 대한 필요한 권리/허가를 보유했음을 확인합니다."
// "tv.vendorActivation.001.c3" = "서비스 운영을 위해 제공된 콘텐츠를 복제, 표시, 번역(예: 일본 사용자용), 그리고 최소한의 편집(예: 서식/크롭)을 하는 것에 동의합니다."
// "tv.vendorActivation.001.c4" = "연락처(이메일/전화)를 제공하는 경우, 로그인한 사용자에게 표시되는 것에 동의합니다. 비즈니스 연락처 사용을 권장합니다."
// "tv.vendorActivation.001.c5" = "언제든지 수정, 숨김, 철회를 요청할 수 있으며, 합리적인 기간(예: 7~14일) 내에 공개 표시를 중단합니다."
// "tv.vendorActivation.001.c6" = "데이터는 클라우드 서비스(예: Google/Firebase)를 통해 저장/처리될 수 있으며, 인프라에 따라 국가 외부에서 처리될 수 있습니다."
// "tv.vendorActivation.001.c7" = "불법, 오해 소지, 제3자 권리 침해 또는 플랫폼 정책 위반 콘텐츠는 숨김 또는 거절될 수 있습니다."
//
// pk_vendor_hide_001 (vendorHide)
// "tv.vendorHide.001.c1" = "고객에게서 해당 벤더가 숨김 처리됩니다."
// "tv.vendorHide.001.c2" = "벤더 포털에서 계속 관리할 수 있습니다."
// "tv.vendorHide.001.c3" = "다시 고객에게 표시하려면 재신청 후 관리자 승인(심사)이 필요합니다."
//
// pk_vendor_archive_001 (vendorArchive)
// "tv.vendorArchive.001.c1" = "벤더의 공개 표시가 중단되며, 벤더 포털 목록에서 제거됩니다."
// "tv.vendorArchive.001.c2" = "보안, 컴플라이언스, 백업 목적상 일부 데이터는 제한된 기간(예: 최대 30일) 보관된 후 삭제 또는 익명화될 수 있습니다."
// "tv.vendorArchive.001.c3" = "보관 후 복구가 제한될 수 있습니다. 복구가 필요하면 가능한 한 빨리 지원팀에 문의하세요."


// MARK: - VendorStatusApplication (vsa)
// Source: VendorStatusApplication.swift
//
// VendorStatusApplicationEventType.displayName
// "vsa.event.submitted" = "제출됨"
// "vsa.event.resubmitted" = "재제출됨"
// "vsa.event.approved" = "승인됨"
// "vsa.event.rejected" = "거절됨"
// "vsa.event.statusApplied" = "상태 적용됨"
//
// VendorStatusRequestType.displayName
// "vsa.request.activate" = "활성화"
// "vsa.request.hide" = "숨김"
// "vsa.request.archive" = "삭제 요청"
//
// VendorStatusDecision.displayName
// "vsa.decision.pending" = "대기 중"
// "vsa.decision.approved" = "승인됨"
// "vsa.decision.rejected" = "거절됨"
//
// StatusRequestAction.title
// "vsa.action.apply.title" = "활성화 신청"
// "vsa.action.resubmit.title" = "재심사 신청"
// "vsa.action.hide.title" = "숨김 요청"
// "vsa.action.archive.title" = "삭제 요청"
//
// StatusRequestAction.primaryButtonTitle
// "vsa.action.apply.primary" = "제출"
// "vsa.action.resubmit.primary" = "제출"
// "vsa.action.hide.primary" = "요청"
// "vsa.action.archive.primary" = "요청"


// MARK: - VendorSummary (vs)
// Source: VendorSummary.swift
//
// VendorSummary.placeholder
// "vs.placeholder.loading" = "로딩 중..."
//
// VendorStatus.displayName
// "vs.status.active" = "활성"
// "vs.status.pending" = "대기 중"
// "vs.status.hidden" = "숨김"
// "vs.status.rejected" = "거절됨"
// "vs.status.archived" = "보관됨"
//
// VendorStatus.uiDescription
// "vs.statusDesc.active" = "이 벤더는 고객에게 표시됩니다."
// "vs.statusDesc.pending" = "요청이 심사 중입니다. 아직 고객에게 보이지 않습니다."
// "vs.statusDesc.rejected" = "요청이 거절되었습니다. 요약을 확인 후 재신청하세요."
// "vs.statusDesc.hidden" = "이 벤더는 고객에게 숨김 처리되었습니다."
// "vs.statusDesc.archived" = "이 벤더는 보관 처리되어 더 이상 노출되지 않습니다."
//
// VendorCategory.displayName
// "vs.category.all" = "전체"
// "vs.category.studio" = "스튜디오"
// "vs.category.dress" = "드레스"
// "vs.category.hairMake" = "헤어 & 메이크"
// "vs.category.planner" = "플래너"
// "vs.category.coupleSnap" = "스냅"


// MARK: - ApplyVendorViewModel (avm)
// Source: ApplyVendorViewModel.swift
//
// primaryRegistrationButtonTitle
// "avm.primary.saveContinue" = "저장하고 계속"
// "avm.primary.updateContinue" = "수정하고 계속"
//
// statusSubtitle
// "avm.statusSubtitle.beforeStart" = "신청을 시작하려면 등록 정보를 저장하세요."
// "avm.statusSubtitle.initial" = "등록을 완료하고 증빙을 제출하세요."
// "avm.statusSubtitle.pending" = "제출 내용을 심사 중입니다."
// "avm.statusSubtitle.approved" = "승인되었습니다. 이제 벤더 기능을 사용할 수 있습니다."
// "avm.statusSubtitle.rejected" = "거절 사유를 확인하고 재신청하세요."
// "avm.statusSubtitle.archived" = "이 신청은 보관 처리되었습니다."
//
// rejectionSummary
// "avm.rejection.fallback" = "거절됨"
//
// errors
// "avm.error.requiredFields" = "필수 항목을 확인해주세요."
// "avm.error.cannotEdit" = "현재 상태에서는 신청을 수정할 수 없습니다."
// "avm.error.saveFirst" = "먼저 등록 정보를 저장해주세요."
// "avm.error.reviewEvidence" = "증빙 내용을 확인해주세요."
//
// success
// "avm.success.evidenceSubmitted" = "증빙이 제출되었습니다. 관리자 심사를 기다려주세요."
//
// alert
// "avm.alert.defaultTitle" = "알림"


// MARK: - EditProfileViewModel (epvm)
// Source: EditProfileViewModel.swift
//
// alerts
// "epvm.alert.dupEmail.title" = "이메일 중복"
// "epvm.alert.dupEmail.msg" = "이미 사용 중인 이메일입니다."
// "epvm.alert.dupUsername.title" = "사용자명 중복"
// "epvm.alert.dupUsername.msg" = "이미 사용 중인 사용자명입니다."
// "epvm.alert.error.title" = "오류"
// "epvm.alert.missingBaseline.msg" = "기준 사용자 정보가 없습니다. 이 화면을 다시 열어주세요."
// "epvm.alert.userNotFound.msg" = "사용자를 찾을 수 없습니다. 잠시 후 다시 시도해주세요."
// "epvm.alert.generic.msg" = "문제가 발생했습니다. 잠시 후 다시 시도해주세요."


// MARK: - LoginViewModel (lvm)
// Source: LoginViewModel.swift
//
// alerts
// "lvm.alert.invalidUsername.title" = "사용자명이 올바르지 않습니다"
// "lvm.alert.invalidUsername.msg" = "사용자명을 다시 확인해주세요."
// "lvm.alert.loginFailed.title" = "로그인 실패"
// "lvm.alert.inactiveUser.msg" = "계정이 비활성화되었거나 종료되었을 수 있습니다. 지원팀에 문의하세요."
// "lvm.alert.invalidPassword.title" = "비밀번호가 올바르지 않습니다"
// "lvm.alert.invalidPassword.msg" = "비밀번호를 다시 확인해주세요."
// "lvm.alert.invalidPassword.hintMsg" = "비밀번호를 다시 확인해주세요. (팁: 비밀번호에 앞/뒤 공백이 포함될 수 있습니다.)"
// "lvm.alert.unexpected.msg" = "예상치 못한 오류가 발생했습니다."


// MARK: - RegisterView (rv)
// Source: RegisterView.swift
//
// labels & placeholders
// "rv.label.emailRequired" = "이메일 *"
// "rv.placeholder.email" = "이메일"
// "rv.label.usernameRequired" = "사용자명 *"
// "rv.placeholder.username" = "사용자명"
// "rv.label.passwordRequired" = "비밀번호 *"
//
// buttons & texts
// "rv.button.submit" = "제출"
// "rv.text.haveAccount" = "이미 계정이 있나요?"
// "rv.button.login" = "로그인"
//
// toast
// "rv.toast.registerSuccess" = "회원가입이 완료되었습니다."


// MARK: - RegisterReviewView (rrv)
// Source: RegisterReviewView.swift
//
// title
// "rrv.title.reviewDetails" = "입력 내용을 확인하세요"
//
// fields
// "rrv.field.email" = "이메일"
// "rrv.field.username" = "사용자명"
// "rrv.field.password" = "비밀번호"
//
// buttons
// "rrv.button.edit" = "수정"
// "rrv.button.register" = "가입하기"


// MARK: - MainListViewModel (mlvm)
// Source: MainListViewModel.swift
//
// alerts
// "mlvm.alert.error.title" = "오류"
// "mlvm.alert.loadFailed.msg" = "벤더를 불러오지 못했습니다. 다시 시도해주세요."


// MARK: - MainViewModel (mvm)
// Source: MainViewModel.swift
//
// alerts
// "mvm.alert.loadFailed.title" = "벤더를 불러오지 못했습니다"
// "mvm.alert.loadFailed.msg" = "다시 시도해주세요."


// MARK: - MarkViewModel (mkvm)
// Source: MarkViewModel.swift
//
// alerts
// "mkvm.alert.loadFailed.title" = "마크한 벤더를 불러오지 못했습니다"
// "mkvm.alert.loadFailed.msg" = "다시 시도해주세요."


// MARK: - ProfileViewModel (pvm)
// Source: ProfileViewModel.swift
//
// messages
// "pvm.message.error.title" = "오류"
// "pvm.message.loginFirst.msg" = "먼저 로그인해주세요."


// MARK: - ReauthViewModel (rvm)
// Source: ReauthViewModel.swift
//
// alerts
// "rvm.alert.invalidUsername.title" = "사용자명이 올바르지 않습니다"
// "rvm.alert.invalidUsername.msg" = "사용자명을 다시 확인해주세요."
// "rvm.alert.loginFailed.title" = "로그인 실패"
// "rvm.alert.inactiveUser.msg" = "계정이 비활성화되었거나 종료되었을 수 있습니다. 지원팀에 문의하세요."
// "rvm.alert.invalidPassword.title" = "비밀번호가 올바르지 않습니다"
// "rvm.alert.invalidPassword.msg" = "비밀번호를 다시 확인해주세요."
// "rvm.alert.invalidPassword.hintMsg" = "비밀번호를 다시 확인해주세요. (팁: 비밀번호에 앞/뒤 공백이 포함될 수 있습니다.)"
// "rvm.alert.unexpected.msg" = "예상치 못한 오류가 발생했습니다."


// MARK: - RegisterViewModel (regvm)
// Source: RegisterViewModel.swift
//
// alerts
// "regvm.alert.dupEmail.title" = "이미 사용 중인 이메일입니다"
// "regvm.alert.dupEmail.msg" = "다른 이메일을 사용해주세요."
// "regvm.alert.dupUsername.title" = "이미 사용 중인 사용자명입니다"
// "regvm.alert.dupUsername.msg" = "다른 사용자명을 사용해주세요."
// "regvm.alert.registerFailed.title" = "회원가입 실패"
// "regvm.alert.createMarkFailed.title" = "마크 생성 실패"
// "regvm.alert.unexpected.msg" = "예상치 못한 오류가 발생했습니다."


// MARK: - VendorDetailViewModel (vdvm)
// Source: VendorDetailViewModel.swift
//
// messages
// "vdvm.message.warning.title" = "경고"
// "vdvm.message.refreshSummaryFailed.msg" = "벤더 요약을 갱신하지 못했습니다."
// "vdvm.message.loadDetailFailed.msg" = "벤더 상세를 불러오지 못했습니다."
// "vdvm.message.loadImagesFailed.msg" = "벤더 이미지를 불러오지 못했습니다."
// "vdvm.message.updateBookmarkFailed.msg" = "북마크를 업데이트하지 못했습니다."
// "vdvm.message.updateBookmarkCountFailed.msg" = "북마크 수 업데이트에 실패했습니다."
//
// alerts
// "vdvm.alert.error.title" = "오류"
// "vdvm.alert.signInToUseBookmarks.msg" = "북마크를 사용하려면 로그인하세요."


// MARK: - LoginView (lv)
// Source: LoginView.swift
//
// labels & placeholders
// "lv.label.username" = "사용자명"
// "lv.placeholder.username" = "username"
// "lv.label.password" = "비밀번호"
//
// buttons
// "lv.button.login" = "로그인"
// "lv.button.signUp" = "회원가입"
// "lv.button.guestLogin" = "게스트로 로그인"
// "lv.button.ok" = "OK"
//
// texts
// "lv.text.noAccount" = "계정이 없나요?"
//
// toast
// "lv.toast.signInSuccess" = "로그인되었습니다."


// MARK: - MainListView (mlv)
// Source: MainListView.swift
//
// filter
// "mlv.filter.label" = "필터"
// "mlv.filter.reset" = "초기화"
// "mlv.filter.allVendors" = "전체 벤더"
//
// order
// "mlv.order.label" = "정렬"
// "mlv.order.nameAsc" = "이름 (A–Z)"
// "mlv.order.nameDesc" = "이름 (Z–A)"
// "mlv.order.mostMarked" = "가장 많이 마크됨"
//
// search
// "mlv.search.prompt" = "검색"


// MARK: - MainView (mv)
// Source: MainView.swift
//
// sections
// "mv.section.category" = "카테고리"
// "mv.section.popularStores" = "인기 스토어"


// MARK: - MarkView (mkv)
// Source: MarkView.swift
//
// texts
// "mkv.text.signInToUseMarks" = "마크를 사용하려면 로그인하세요."
// "mkv.text.noMarkFound" = "마크가 없습니다"
// "mkv.text.signInAgainIfIncorrect" = "이 내용이 맞지 않다면, 다시 로그인해주세요."
//
// alerts
// "mkv.alert.signInRequired.title" = "로그인이 필요합니다"
//
// buttons
// "mkv.button.ok" = "OK"


// MARK: - ApplyVendorView (av)
// Source: ApplyVendorView.swift
//
// toast
// "av.toast.completeRegistrationFirst" = "먼저 등록을 완료해주세요."
// "av.toast.copied" = "복사했습니다."
//
// common
// "av.button.ok" = "OK"
// "av.text.waitUntilReviewed" = "신청이 심사될 때까지 기다려주세요."
// "av.tab.registration" = "등록"
// "av.tab.evidence" = "증빙"
// "av.status.format" = "상태: %@"
// "av.rejectionReason.title" = "거절 사유"
//
// sections
// "av.section.applicant" = "신청자"
// "av.section.businessOptional" = "사업 정보(선택)"
// "av.section.confirmations" = "확인"
// "av.section.messageToAdminOptional" = "관리자에게 메시지(선택)"
//
// fields
// "av.field.name" = "이름"
// "av.field.role" = "역할"
// "av.field.email" = "이메일"
// "av.field.phone" = "전화"
// "av.field.business" = "사업"
// "av.field.category" = "카테고리"
//
// placeholders
// "av.placeholder.applicantNameRequired" = "신청자 이름(필수)"
// "av.placeholder.roleTitleRequired" = "역할/직함(필수)"
// "av.placeholder.emailOptional" = "이메일(선택)"
// "av.placeholder.phoneOptional" = "전화(선택)"
// "av.placeholder.brandName" = "브랜드/사업명"
// "av.placeholder.vendorCategoryExample" = "벤더 카테고리(예: 스튜디오, 드레스, 헤어&메이크 등)"
// "av.placeholder.additionalMessage" = "추가 메시지"
//
// checkboxes
// "av.checkbox.authority" = "본 사업을 대표할 권한이 있습니다"
// "av.checkbox.rights" = "업로드 자료(저작권/초상권 등)에 필요한 권리를 확보했습니다"
//
// confirmed
// "av.confirmed.format" = "확인됨: %@"
//
// evidence
// "av.evi.text.completeRegistrationTabFirst" = "먼저 등록 탭을 완료해주세요."
// "av.evi.text.underReviewCannotEdit" = "신청이 심사 중입니다. (증빙은 수정할 수 없습니다)"
// "av.evi.section.verificationMethod" = "인증 방식"
// "av.evi.method.officialEmail" = "공식 이메일"
// "av.evi.method.verificationCode" = "인증 코드"
// "av.evi.step1.inputFields" = "1단계: 입력"
// "av.evi.step2.sendEmail" = "2단계: 이메일 보내기"
// "av.evi.step2.postCode" = "2단계: 코드 게시"
// "av.evi.step3.submit" = "3단계: 제출"
// "av.evi.bullet.useOfficialEmail" = "• 공식 링크에 표시되거나 사용 중인 이메일을 사용해주세요."
// "av.evi.bullet.sendToBelowAddress" = "• 1단계에서 입력한 이메일로 아래 주소에 메일을 보내주세요."
// "av.evi.bullet.copyEmailTitle" = "• 이메일 제목은 아래를 복사해 붙여넣어 주세요."
// "av.evi.bullet.noEmailBodyNeeded" = "• 이메일 본문은 입력하지 않아도 됩니다."
// "av.evi.bullet.urlWhereCodePosted" = "• URL: 인증 코드를 게시할 URL을 입력하세요."
// "av.evi.bullet.detailWhereCodePosted" = "• 상세: 코드가 게시된 위치를 구체적으로 적어주세요. (예: 스토리, 프로필 소개 등)"
// "av.evi.bullet.postCodeThenSubmit" = "• 공식 채널에 아래 인증 코드를 게시한 뒤 제출하세요."
// "av.evi.bullet.channelsExample" = "• 채널 예시: 웹사이트, 인스타그램, 유튜브, X 등"
// "av.evi.bullet.removeAfterApproved" = "• 신청이 승인되면 인증 코드는 바로 삭제해도 됩니다."
// "av.evi.text.contactIfNoMethod" = "두 가지 방법 모두 어렵다면 직접 문의해주세요. 다른 방법도 제공할 수 있도록 개발 중입니다."
// "av.evi.field.url" = "URL"
// "av.evi.field.detail" = "상세"
// "av.evi.placeholder.emailHintExample" = "pumpkin@example.com"
// "av.evi.placeholder.emailLink" = "이메일이 표시되거나 사용되는 링크"
// "av.evi.placeholder.channelUrl" = "코드를 게시할 채널 URL"
// "av.evi.placeholder.channelDetail" = "코드가 게시된 위치를 간단히 설명"
// "av.evi.label.emailTo" = "받는 사람"
// "av.evi.value.contactEmail" = "contact@example.com"
// "av.evi.label.emailTitle" = "이메일 제목"
// "av.evi.emailTitle.format" = "[RoleApplication][Email] User:%@ Code:%@"
// "av.evi.label.verificationCode" = "인증 코드"
// "av.evi.button.submitEvidence" = "증빙 제출"


// MARK: - ApplyCurtainView (avc)
// Source: ApplyVendorView.swift
//
// title & text
// "avc.title.becomeVendor" = "벤더로 등록하기"
// "avc.text.subtitle" = "공식 채널을 확인할 수 있도록 등록을 완료하고 증빙 한 가지를 제출해주세요."
//
// steps
// "avc.step.registration.title" = "등록"
// "avc.step.registration.detail" = "역할 및 사업 기본 정보"
// "avc.step.evidence.title" = "증빙"
// "avc.step.evidence.detail" = "공식 이메일 또는 인증 코드"
// "avc.step.submit.title" = "제출"
// "avc.step.submit.detail" = "검토 후 안내드립니다"
//
// buttons
// "avc.button.startApplication" = "신청 시작"
// "avc.button.notNow" = "나중에"
//
// navigation

// "avc.nav.vendorApplication" = "벤더 신청"



// MARK: - EditProfileView (epv)
// Source: EditProfileView.swift
//
// title
// "epv.title.editProfile" = "프로필 수정"
//
// labels & placeholders
// "epv.label.email" = "이메일"
// "epv.placeholder.email" = "이메일"
// "epv.label.username" = "사용자명"
// "epv.placeholder.username" = "사용자명"
// "epv.label.password" = "비밀번호"
//
// buttons
// "epv.button.save" = "저장"
// "epv.button.ok" = "OK"
//
// discard alert
// "epv.discard.title" = "변경사항을 버릴까요?"
// "epv.discard.message" = "저장되지 않은 변경사항이 있습니다."
// "epv.discard.discard" = "버리기"
// "epv.discard.cancel" = "취소"



// MARK: - FAQView (faqv)
// Source: FAQView.swift
//
// title
// "faqv.title.faqs" = "자주 묻는 질문"
//
// categories
// "faqv.category.account" = "계정 관련"
// "faqv.category.vendor" = "벤더 관련"
// "faqv.category.app" = "앱 관련"
// "faqv.category.privacy" = "개인정보 관련"
// "faqv.category.other" = "기타"
//
// questions
// "faqv.q.account.delete.title" = "계정을 어떻게 삭제하나요?"
// "faqv.q.account.delete.body" = "계정을 영구적으로 삭제하려면 프로필 메뉴의 문의(Inquiry) 탭을 통해 연락해주세요."
// "faqv.q.account.changeUsername.title" = "사용자명을 변경하려면 어떻게 하나요?"
// "faqv.q.account.changeUsername.body" = "사용자명을 변경하려면 프로필 메뉴의 프로필 수정 기능을 사용해주세요."
// "faqv.q.account.changePassword.title" = "비밀번호를 변경하려면 어떻게 하나요?"
// "faqv.q.account.changePassword.body" = "비밀번호를 변경하려면 프로필 메뉴의 프로필 수정 기능을 사용해주세요."
// "faqv.q.vendor.contactVendor.title" = "벤더에게 문의할 수 있나요?"
// "faqv.q.vendor.contactVendor.body" = "벤더에게 직접 연락할 수 있는 기능을 개발 중입니다. 추후 안내를 기다려주세요."
// "faqv.q.vendor.products.title" = "벤더에서 제공하는 상품은 무엇인가요?"
// "faqv.q.vendor.products.body" = "상품 상세를 지원하기 위해 벤더들과 협의 중입니다. 조금만 기다려주세요."
// "faqv.q.vendor.purpose.title" = "스튜디오, 드레스, 헤어&메이크업의 목적이 무엇인가요?"
// "faqv.q.vendor.purpose.body" = "프리웨딩 촬영에서 스튜디오는 사진 촬영을 담당하는 곳, 드레스는 촬영용 웨딩드레스 대여 서비스, 헤어 & 메이크업은 촬영을 위한 스타일링을 도와주는 서비스입니다."
// "faqv.q.app.notifications.title" = "알림 설정은 어떻게 하나요?"
// "faqv.q.app.notifications.body" = "현재 해당 기능은 없습니다. 개발을 기다려주세요."
// "faqv.q.app.deleteInfo.title" = "앱을 삭제하면 내 정보도 삭제되나요?"
// "faqv.q.app.deleteInfo.body" = "프로필 메뉴의 문의(Inquiry) 탭을 통해 직접 문의해주세요."



// MARK: - NotificationsView (nv)
// Source: NotificationsView.swift
//
// title
// "nv.title.notifications" = "알림"
//
// categories
// "nv.category.info" = "[정보]"
// "nv.category.warning" = "[경고]"
// "nv.category.error" = "[오류]"
// "nv.category.maintenance" = "[점검]"
//
// mock notifications
// "nv.mock.1.title" = "iOS 업데이트 관련"
// "nv.mock.1.body" = "TEST 내용. TEST 내용 TEST 내용. TEST 내용 TEST 내용 TEST 내용 TEST 내용... TEST 내용.TEST 내용.TEST 내용.TEST 내용."
// "nv.mock.2.title" = "수상한 전화를 받지 마세요."
// "nv.mock.2.body" = "TEST 내용. TEST 내용 TEST 내용. TEST 내용 TEST 내용 TEST 내용 TEST 내용... TEST 내용.TEST 내용.TEST 내용.TEST 내용."
// "nv.mock.3.title" = "2025.01.01 점검 예정"
// "nv.mock.3.body" = "TEST 내용. TEST 내용 TEST 내용. TEST 내용 TEST 내용 TEST 내용 TEST 내용... TEST 내용.TEST 내용.TEST 내용.TEST 내용."
// "nv.mock.4.title" = "2025.03.01 점검 예정"
// "nv.mock.4.body" = "TEST 내용. TEST 내용 TEST 내용. TEST 내용 TEST 내용 TEST 내용 TEST 내용... TEST 내용.TEST 내용.TEST 내용.TEST 내용."
// "nv.mock.5.title" = "iOS 업데이트 관련"
// "nv.mock.5.body" = "TEST 내용. TEST 내용 TEST 내용. TEST 내용 TEST 내용 TEST 내용 TEST 내용... TEST 내용.TEST 내용.TEST 내용.TEST 내용."



// MARK: - ProfileView (pv)
// Source: ProfileView.swift
//
// sections
// "pv.section.general" = "일반"
// "pv.section.help" = "도움말"
// "pv.section.vendorMenu" = "벤더 메뉴"
// "pv.section.adminMenu" = "관리자 메뉴"
//
// buttons
// "pv.button.setting" = "설정"
// "pv.button.notifications" = "알림"
// "pv.button.faq" = "FAQ"
// "pv.button.inquiry" = "문의"
// "pv.button.signOut" = "로그아웃"
// "pv.button.signInSignUp" = "로그인 / 회원가입"
// "pv.button.cancel" = "취소"
// "pv.button.ok" = "OK"
// "pv.button.vendorPortal" = "벤더 포털"
// "pv.button.applyVendor" = "벤더 신청"
// "pv.button.adminPortal" = "관리자 포털"
//
// alerts
// "pv.alert.signOut.title" = "로그아웃"
// "pv.alert.signOut.msg" = "정말 로그아웃할까요?"
//
// mail
// "pv.mail.unavailable.title" = "메일 앱에 접근할 수 없습니다"
// "pv.mail.unavailable.msg" = "메일 앱에 로그인한 뒤 다시 시도해주세요."
// "pv.inquiry.subject.guest" = "[게스트] 문의"
// "pv.inquiry.subject.normal" = "문의"
// "pv.inquiry.body" = "도움을 드릴 수 있도록 가능한 한 자세히 적어주세요."
//
// user fallbacks
// "pv.user.guest" = "게스트"
// "pv.user.default" = "Mr. Pumpkin"
//
// messages
// "pv.message.accessDenied.title" = "접근 거부"
// "pv.message.accessDenied.vendorOrAdmin.msg" = "벤더/관리자 계정으로 로그인해주세요."
// "pv.message.accessDenied.admin.msg" = "관리자 계정으로 로그인해주세요."
// "pv.message.notSignedIn.title" = "로그인되지 않음"
// "pv.message.notSignedIn.msg" = "접근하려면 로그인해주세요."
// "pv.message.loginFailed.title" = "로그인 실패"
// "pv.message.loginFailed.differentUser.msg" = "현재 로그인된 계정으로 로그인해주세요."
// "pv.message.loginFailed.tryAgain.msg" = "다시 시도해주세요."



// MARK: - ReauthView (reav)
// Source: ReauthView.swift
//
// labels & placeholders
// "reav.label.username" = "사용자명"
// "reav.placeholder.username" = "username"
// "reav.label.password" = "비밀번호"
//
// buttons
// "reav.button.login" = "로그인"
// "reav.button.ok" = "OK"
//
// texts
// "reav.text.loginAgainToProceed" = "계속하려면 다시 로그인해주세요"
//
// toast
// "reav.toast.signInAgain" = "다시 로그인해주세요."
// "reav.toast.loginFailed" = "로그인에 실패했습니다. 사용자명과 비밀번호를 확인해주세요."
// "reav.toast.confirmSuccess" = "재인증에 성공했습니다."
// "reav.toast.useCurrentAccount" = "현재 로그인된 계정으로 로그인해주세요."



// MARK: - SettingView (setv)
// Source: SettingView.swift
//
// titles
// "setv.title.settings" = "설정"
//
// rows & navigation
// "setv.row.appVersion" = "앱 버전"
// "setv.nav.terms" = "이용약관"
// "setv.nav.privacy" = "개인정보처리방침"
// "setv.nav.language" = "언어"
//
// language options
// "setv.lang.systemDefault" = "시스템 기본값"
// "setv.lang.ko" = "한국어"
// "setv.lang.en" = "English"
// "setv.lang.ja" = "日本語"



// MARK: - VendorDetailView (vdv)
// Source: VendorDetailView.swift
//
// share
// "vdv.share.checkOutVendor" = "PumpkinCarriage에서 이 벤더를 확인해보세요."
//
// alerts
// "vdv.alert.openExternal.title" = "외부 링크를 열까요?"
//
// buttons
// "vdv.button.open" = "열기"
// "vdv.button.cancel" = "취소"
// "vdv.button.ok" = "OK"



// MARK: - VendorManageViewModel (vmanvm)
// Source: VendorManageViewModel.swift
//
// alerts
// "vmanvm.alert.permissionDenied.title" = "권한 없음"
// "vmanvm.alert.permissionDenied.msg" = "벤더 계정만 벤더를 관리할 수 있습니다. 벤더 계정으로 로그인한 뒤 다시 시도해주세요."
// "vmanvm.alert.error.title" = "오류"
// "vmanvm.alert.accessConfirmFailed.msg" = "접근 확인 중 문제가 발생했습니다. 잠시 후 다시 시도해주세요."
// "vmanvm.alert.loadFailed.title" = "벤더를 불러오지 못했습니다"
// "vmanvm.alert.tryAgain.msg" = "다시 시도해주세요."



// MARK: - VendorReviewViewModel (vrvm)
// Source: VendorReviewViewModel.swift
//
// messages
// "vrvm.message.warning.title" = "경고"
// "vrvm.message.refreshSummaryFailed.msg" = "벤더 요약을 갱신하지 못했습니다."
// "vrvm.message.loadDetailFailed.msg" = "벤더 상세를 불러오지 못했습니다."
// "vrvm.message.loadImagesFailed.msg" = "벤더 이미지를 불러오지 못했습니다."



// MARK: - VendorStatusViewModel (vsvm)
// Source: VendorStatusViewModel.swift
//
// success
// "vsvm.success.requestReceived" = "요청을 접수했습니다."
//
// alerts
// "vsvm.alert.permissionDenied.title" = "권한 없음"
// "vsvm.alert.permissionDenied.msg" = "벤더만 접근할 수 있습니다. 로그인 후 다시 시도해주세요."
// "vsvm.alert.error.title" = "오류"
// "vsvm.alert.userContextMissing.msg" = "사용자 컨텍스트가 없습니다. 다시 로그인해주세요."
// "vsvm.alert.warning.title" = "경고"
// "vsvm.alert.refreshSummaryFailed.msg" = "벤더 요약을 갱신하지 못했습니다."
// "vsvm.alert.loadDetailFailed.msg" = "벤더 상세를 불러오지 못했습니다."
// "vsvm.alert.duplicatePending.title" = "요청이 이미 존재합니다"
// "vsvm.alert.duplicatePending.msg" = "이전 요청 처리를 기다려주세요."
// "vsvm.alert.saveFailed.title" = "저장 실패"
// "vsvm.alert.saveFailed.userContextMissing.msg" = "상태 요청을 제출했지만 사용자 컨텍스트가 없습니다. 다시 시도해주세요."
// "vsvm.alert.saveFailed.updateStatusFailed.msg" = "상태 요청을 제출했지만 벤더 상태 업데이트에 실패했습니다. 다시 시도해주세요."
// "vsvm.alert.statusAppNotFound.msg" = "상태 신청을 찾을 수 없습니다."
// "vsvm.alert.submitFailed.msg" = "요청 제출에 실패했습니다."



// MARK: - VendorUpdateViewModel (vuvm)
// Source: VendorUpdateViewModel.swift
//
// alerts
// "vuvm.alert.permissionDenied.title" = "권한 없음"
// "vuvm.alert.permissionDenied.msg" = "벤더 계정만 벤더를 등록하거나 관리할 수 있습니다. 벤더 계정으로 로그인한 뒤 다시 시도해주세요."
// "vuvm.alert.loginAgain.msg" = "다시 로그인해주세요."
// "vuvm.alert.error.title" = "오류"
// "vuvm.alert.vendorNotFound.msg" = "벤더를 찾을 수 없거나 접근 권한이 없습니다."
// "vuvm.alert.vendorDetailNotFound.msg" = "벤더 상세 정보를 찾을 수 없습니다. 잠시 후 다시 시도해주세요."
// "vuvm.alert.loadVendorFailed.msg" = "벤더를 불러오지 못했습니다. 잠시 후 다시 시도해주세요."
// "vuvm.alert.updateNotAllowed.title" = "수정 불가"
// "vuvm.alert.updateNotAllowed.msg" = "현재 상태에서는 벤더 정보를 수정할 수 없습니다."
// "vuvm.alert.invalidLinkType.title" = "링크 타입이 올바르지 않습니다"
// "vuvm.alert.invalidLinkType.msg" = "먼저 링크 타입을 선택해주세요."
// "vuvm.alert.imageLimit.title" = "이미지 제한 초과"
// "vuvm.alert.imageLimit.format" = "최대 %d장까지 업로드할 수 있습니다."
// "vuvm.alert.noChanges.title" = "변경사항 없음"
// "vuvm.alert.noChanges.msg" = "수정할 내용이 없습니다."
// "vuvm.alert.sessionInvalid.msg" = "세션이 유효하지 않습니다. 다시 로그인해주세요."
// "vuvm.alert.tryAgain.msg" = "다시 시도해주세요."
//
// validation
// "vuvm.validation.storeName.invalid.title" = "스토어명이 올바르지 않습니다"
// "vuvm.validation.storeName.invalid.msg" = "스토어명을 입력해주세요."
// "vuvm.validation.category.invalid.title" = "카테고리가 올바르지 않습니다"
// "vuvm.validation.category.invalid.msg" = "유효한 카테고리를 선택해주세요."
// "vuvm.validation.country.invalid.title" = "국가가 올바르지 않습니다"
// "vuvm.validation.country.invalid.msg" = "유효한 국가를 선택해주세요."
// "vuvm.validation.city.invalid.title" = "도시가 올바르지 않습니다"
// "vuvm.validation.city.invalid.msg" = "도시를 선택해주세요."
// "vuvm.validation.district.invalid.title" = "구/군이 올바르지 않습니다"
// "vuvm.validation.district.invalid.msg" = "구/군을 입력해주세요."
// "vuvm.validation.address.invalid.title" = "주소 상세가 올바르지 않습니다"
// "vuvm.validation.address.invalid.msg" = "최소한 도로명 또는 건물명을 입력해주세요."
// "vuvm.validation.language.required.title" = "언어 선택이 필요합니다"
// "vuvm.validation.language.required.msg" = "지원 언어를 최소 1개 선택해주세요."
// "vuvm.validation.description.required.title" = "설명이 필요합니다"
// "vuvm.validation.description.required.msg" = "일본어 설명은 필수입니다."
// "vuvm.validation.description.tooShort.title" = "설명이 너무 짧습니다"
// "vuvm.validation.description.tooShort.msg" = "JP 설명은 최소 10자 이상 입력해주세요."
//
// success
// "vuvm.success.updated.title" = "벤더 업데이트 완료"
// "vuvm.success.registered.title" = "벤더 등록 완료"
// "vuvm.success.registered.msg" = "‘벤더 관리(Manage Vendor)’ 메뉴에서 확인해주세요."



// MARK: - StatusApplicationView (sav)
// Source: StatusApplicationView.swift
//
// alerts
// "sav.alert.cancel" = "취소"
// "sav.alert.confirm" = "확인"
//
// buttons
// "sav.button.close" = "닫기"
//
// confirmations
// "sav.confirm.hide.format" = "'%@'을(를) 숨길까요?"
// "sav.confirm.delete.format" = "'%@'을(를) 삭제할까요?"
//
// vendor
// "sav.vendorId.format" = "벤더 ID: %@"
//
// terms
// "sav.card.termsAgreement" = "약관 및 동의"
// "sav.terms.notAvailable" = "약관을 불러올 수 없습니다."
// "sav.consent.agreeProceed" = "위 내용을 이해했으며 동의하고 진행합니다."
// "sav.consent.archiveAgree" = "공개 표시가 중단되며 데이터 삭제에 시간이 걸릴 수 있음을 이해합니다."
//
// notes
// "sav.notes.titleOptional" = "메모(선택)"
// "sav.notes.placeholder" = "검토자에게 간단한 메모를 남기세요"
//
// hint
// "sav.hint.submitEnabled" = "약관에 동의하면 제출/요청이 활성화됩니다."



// MARK: - VendorGuideView (vgv)
// Source: VendorGuideView.swift
//
// title
// "vgv.title.guideToManagingVendors" = "벤더 관리 가이드"
//
// categories
// "vgv.category.register" = "벤더 등록"
// "vgv.category.reviewEdit" = "등록된 벤더 확인 / 수정"
// "vgv.category.changeStatus" = "벤더 상태 변경"
//
// guides
// "vgv.guide.register.01" = "'벤더 등록' 메뉴를 선택하세요."
// "vgv.guide.register.02" = "모든 필수 항목을 입력하세요."
// "vgv.guide.register.03" = "'제출' 버튼을 누르세요."
// "vgv.guide.register.04" = "문제가 없다면 성공 알림이 표시됩니다."
// "vgv.guide.reviewEdit.01" = "'벤더 관리' 메뉴를 선택하세요."
// "vgv.guide.reviewEdit.02" = "목록에서 벤더를 탭하면 선택한 벤더를 확인할 수 있습니다."
// "vgv.guide.reviewEdit.03" = "상세 화면에서 '수정' 버튼을 눌러 정보를 변경할 수 있습니다."
// "vgv.guide.reviewEdit.04" = "수정 화면에서 원하는 항목을 변경하세요."
// "vgv.guide.reviewEdit.05" = "'변경사항 저장' 버튼을 눌러 저장하세요."
// "vgv.guide.changeStatus.01" = "'벤더 관리' 메뉴를 선택하세요."
// "vgv.guide.changeStatus.02" = "'상태' 스위치를 토글해 벤더 상태를 변경하세요."
// "vgv.guide.changeStatus.03" = "상태 변경 시 알림이 표시됩니다. 'OK'를 눌러 진행하세요."
// "vgv.guide.changeStatus.04" = "확인되면 벤더가 '활성' 상태로 변경되어 고객에게 표시됩니다."



// MARK: - VendorManageView (vmv)
// Source: VendorManageView.swift
//
// title
// "vmv.title.myVendors" = "내 벤더"
//
// texts
// "vmv.text.noManagedVendors" = "아직 관리 중인 벤더가 없습니다."
//
// buttons
// "vmv.button.ok" = "OK"



// MARK: - VendorPortalView (vpv)
// Source: VendorPortalView.swift
//
// title
// "vpv.title.vendorPortal" = "벤더 포털"
//
// sections
// "vpv.section.accountInfo" = "계정 정보"
//
// user
// "vpv.user.format" = "사용자: %@"
//
// texts
// "vpv.text.manageVendorsHere" = "여기서 벤더를 관리할 수 있습니다."
//
// actions
// "vpv.action.register.title" = "벤더 등록"
// "vpv.action.register.subtitle" = "새 벤더 프로필 생성"
// "vpv.action.manage.title" = "벤더 관리"
// "vpv.action.manage.subtitle" = "스토어 정보 수정"
// "vpv.action.guide.title" = "벤더 가이드"
// "vpv.action.guide.subtitle" = "벤더 기능 안내"



// MARK: - VendorReviewView (vrv)
// Source: VendorReviewView.swift
//
// buttons
// "vrv.button.edit" = "수정"
// "vrv.button.open" = "열기"
// "vrv.button.cancel" = "취소"
//
// alerts
// "vrv.alert.openExternal.title" = "외부 링크를 열까요?"



// MARK: - VendorStatusView (vsv)
// Source: VendorStatusView.swift
//
// title
// "vsv.title.status" = "상태"
//
// buttons
// "vsv.button.ok" = "OK"
//
// sections
// "vsv.section.timeline" = "타임라인"
// "vsv.section.actions" = "액션"
//
// timeline labels
// "vsv.timeline.created" = "생성"
// "vsv.timeline.updated" = "수정"
// "vsv.timeline.vendorId" = "벤더 ID"
//
// actions
// "vsv.action.underReview" = "심사 중"
// "vsv.action.applyActivation" = "활성화 신청"
// "vsv.action.resubmitReview" = "재심사 신청"
// "vsv.action.edit" = "수정"
// "vsv.action.requestHide" = "숨김 요청"
// "vsv.action.requestDelete" = "삭제 요청"
// "vsv.action.contactSupport" = "지원팀 문의"
//
// rejection summary
// "vsv.reject.title" = "거절 요약"
// "vsv.reject.reason" = "사유"
// "vsv.reject.reasonBody" = "콘텐츠 수정이 필요합니다."
// "vsv.reject.notes" = "메모"
// "vsv.reject.notesBody" = "벤더 정보를 수정한 뒤 재심사를 신청해주세요."
//
// requirements
// "vsv.requirements.title" = "활성화 요구사항"
// "vsv.requirements.image" = "이미지 1장 이상"
// "vsv.requirements.contact" = "연락처 (이메일 또는 전화)"
// "vsv.requirements.description" = "설명 작성 완료"
// "vsv.requirements.terms" = "약관 동의"



// MARK: - VendorUpdateView (vuv)
// Source: VendorUpdateView.swift
//
// navigation
// "vuv.nav.back" = "뒤로"
//
// titles
// "vuv.title.register" = "벤더 등록"
// "vuv.title.update" = "벤더 수정"
//
// submit
// "vuv.submit.submitting" = "제출 중..."
// "vuv.submit.saving" = "저장 중..."
// "vuv.submit.submit" = "제출"
// "vuv.submit.saveChanges" = "변경사항 저장"
//
// discard
// "vuv.discard.title" = "변경사항을 버릴까요?"
// "vuv.discard.keepEditing" = "계속 편집"
// "vuv.discard.discard" = "버리기"
// "vuv.discard.message" = "저장되지 않은 변경사항이 있습니다. 지금 뒤로 가면 수정 내용이 사라집니다."
//
// update confirm
// "vuv.updateConfirm.title" = "벤더를 수정할까요?"
// "vuv.updateConfirm.message" = "관리자 승인 전까지 벤더가 고객에게 숨김 처리됩니다. (상태 변경 요청 필요)"
//
// common buttons
// "vuv.button.ok" = "OK"
// "vuv.button.cancel" = "취소"
// "vuv.button.confirm" = "확인"
// "vuv.button.add" = "추가"
// "vuv.button.remove" = "삭제"
//
// sections
// "vuv.section.basicInfo" = "기본 정보"
// "vuv.section.location" = "위치"
// "vuv.section.languages" = "언어"
// "vuv.section.description" = "설명"
// "vuv.section.contactOptional" = "연락처(선택)"
// "vuv.section.externalLinkOptional" = "외부 링크(선택)"
// "vuv.section.imagesOptional" = "이미지(선택)"
//
// fields
// "vuv.field.name" = "이름"
// "vuv.field.category" = "카테고리"
// "vuv.field.country" = "국가"
// "vuv.field.city" = "도시"
// "vuv.field.district" = "구/군"
// "vuv.field.districtOther" = "구/군(기타)"
// "vuv.field.street" = "주소"
// "vuv.field.email" = "이메일"
// "vuv.field.phone" = "전화"
// "vuv.field.linkType" = "타입"
//
// placeholders
// "vuv.placeholder.vendorNameEng" = "벤더명(영문)"
// "vuv.placeholder.email" = "이메일"
// "vuv.placeholder.phone" = "전화"
// "vuv.placeholder.linkDetails" = "상세"
// "vuv.placeholder.districtEng" = "구/군 입력(영문)"
// "vuv.placeholder.streetEng" = "상세 주소(영문)"
// "vuv.placeholder.loading" = "로딩 중"
//
// notices
// "vuv.notice.title" = "안내"
// "vuv.notice.body" = "벤더 정보를 수정하면 관리자 승인 전까지 벤더가 숨김 처리됩니다. 수정 후 상태 심사를 다시 신청해주세요."
// "vuv.notice.englishRequired" = "* 이름, 구/군(기타), 주소는 영문(로마자)으로 입력해야 합니다."
//
// district
// "vuv.district.manualInput.format" = "%@ (직접 입력)"
//
// links
// "vuv.link.other" = "기타"
//
// images
// "vuv.images.none" = "(이미지 없음)"
// "vuv.images.main" = "*메인 "
// "vuv.images.thumbnailHint" = " 목록에서 썸네일로 표시됩니다."
// "vuv.images.remove.title" = "이미지를 삭제할까요?"
// "vuv.images.remove.msg" = "이 작업은 되돌릴 수 없습니다."
// "vuv.images.mainLabel" = "메인"
// "vuv.images.setMain" = "메인으로 설정"
//
// drag
// "vuv.drag.move" = "이동"



// MARK: - AdminPortalViewModel (apvm)
// Source: AdminPortalViewModel.swift
//
// alerts
// "apvm.alert.permissionDenied.title" = "권한 없음"
// "apvm.alert.permissionDenied.msg" = "관리자만 접근할 수 있습니다. 관리자 계정으로 로그인한 뒤 다시 시도해주세요."



// MARK: - RoleApplicationForm (raf)
// Source: RoleApplicationForm.swift
//
// evidence helper
// "raf.evidenceHelper.officialEmail" = "공식 이메일 힌트와 해당 이메일이 표시되거나 사용되는 공개 URL을 입력한 뒤, 아래 주소로 이메일을 보내주세요."
// "raf.evidenceHelper.codePost" = "공식 채널(웹사이트, 인스타그램, 유튜브, X 등)에 인증 코드를 게시한 뒤, URL과 위치 상세를 입력해 제출하세요."



// MARK: - Validation (vld)
// Source: Validation.swift
//
// titles
// "vld.title.invalidEmail" = "이메일이 올바르지 않습니다"
// "vld.title.invalidPassword" = "비밀번호가 올바르지 않습니다"
// "vld.title.invalidUsername" = "사용자명이 올바르지 않습니다"
// "vld.title.invalid" = "올바르지 않습니다"
// "vld.title.invalidInput" = "입력이 올바르지 않습니다"
// "vld.title.invalidPhone" = "전화번호가 올바르지 않습니다"
// "vld.title.invalidExternalLink" = "외부 링크가 올바르지 않습니다"
//
// messages
// "vld.msg.requiredFields" = "모든 필수 항목을 입력해주세요."
// "vld.msg.emailMin.format" = "이메일은 %d자 이상이어야 합니다."
// "vld.msg.emailFormat" = "유효한 이메일 주소를 입력해주세요."
// "vld.msg.passwordMin.format" = "비밀번호는 %d자 이상이어야 합니다."
// "vld.msg.usernameRange.format" = "사용자명은 %d~%d자 사이여야 합니다."
// "vld.msg.usernameChars" = "사용자명은 영문/숫자/점(.), 밑줄(_), 하이픈(-)만 사용할 수 있습니다."
// "vld.msg.loginEmpty" = "사용자명과 비밀번호는 비어 있을 수 없습니다."
// "vld.msg.phoneCountryCodeRequired" = "전화번호의 국가 코드를 선택해주세요."
// "vld.msg.phoneDigitsOnly" = "숫자만 입력해주세요. (공백/기호 제외)"
// "vld.msg.phoneMinDigits.format" = "전화번호는 최소 %d자리 이상 입력해주세요."
// "vld.msg.externalLinkFields" = "외부 링크 항목은 모두 입력하거나 빈 줄을 삭제해주세요."
// "vld.msg.phoneNumberRequired" = "전화번호를 입력하거나 국가 코드를 해제해주세요."
//
// english-only helper
// "vld.englishOnly.title.format" = "%@이(가) 올바르지 않습니다"
// "vld.englishOnly.msg.format" = "%@은(는) 영문(로마자)으로 입력해주세요."



// MARK: - VendorWriteService (vws)
// Source: VendorWriteService.swift
//
// alerts
// "vws.alert.permissionDenied.title" = "권한 없음"
// "vws.alert.error.title" = "오류"
// "vws.alert.imageUploadFailed.title" = "이미지 업로드 실패"
// "vws.alert.saveFailed.title" = "저장 실패"
// "vws.alert.updateNotAllowed.title" = "수정 불가"
//
// messages
// "vws.alert.tryAgain.msg" = "다시 시도해주세요."
// "vws.alert.registerOnlyVendorOrAdmin.msg" = "벤더 또는 관리자만 벤더를 등록할 수 있습니다."
// "vws.alert.registerSaveFailed.msg" = "벤더 등록에 실패했습니다. 다시 시도해주세요."
// "vws.alert.sessionInvalid.msg" = "세션이 유효하지 않습니다. 다시 로그인해주세요."
// "vws.alert.vendorNotFoundForUpdate.msg" = "수정할 벤더를 찾을 수 없습니다."
// "vws.alert.updateNotAllowed.msg" = "현재 벤더가 심사 중이거나 보관 상태입니다. 잠시 후 다시 시도해주세요."
// "vws.alert.noPermissionToEdit.msg" = "이 벤더를 수정할 권한이 없습니다."
// "vws.alert.updateSaveFailed.msg" = "벤더 업데이트에 실패했습니다. 다시 시도해주세요."
// "vws.alert.updateStatusOnlyVendorOrAdmin.msg" = "벤더 또는 관리자만 벤더 상태를 업데이트할 수 있습니다."
// "vws.alert.vendorNotFound.msg" = "벤더를 찾을 수 없습니다."
// "vws.alert.noPermissionToUpdate.msg" = "벤더를 업데이트할 권한이 없습니다."



// MARK: - ImageResourceView (irv)
// Source: ImageResourceView.swift
//
// placeholder
// "irv.placeholder.imageNotFound" = "이미지를 찾을 수 없습니다"
// "irv.placeholder.failedToLoad" = "불러오기에 실패했습니다"



// MARK: - PasswordComponentView (pcv)
// Source: PasswordComponentView.swift
//
// placeholders
// "pcv.placeholder.password" = "비밀번호"



// MARK: - VendorDetailComponentView (vdcv)
// Source: VendorDetailComponentView.swift
//
// toasts
// "vdcv.toast.waitMoment" = "잠시만 기다려주세요."
// "vdcv.toast.copied" = "복사했습니다."
// "vdcv.toast.signInToCopy" = "복사하려면 로그인하세요."
// "vdcv.toast.signInToShare" = "공유하려면 로그인하세요."
// "vdcv.toast.signInToUseBookmarks" = "북마크를 사용하려면 로그인하세요."
// "vdcv.toast.signInToOpenLinks" = "외부 링크를 열려면 로그인하세요."
//
// sheet
// "vdcv.sheet.introTitle.format" = "%@ 소개"
//
// alert
// "vdcv.alert.copy.title" = "클립보드에 복사할까요?"
//
// buttons
// "vdcv.button.copy" = "복사"
// "vdcv.button.cancel" = "취소"
// "vdcv.button.seeMore" = "더 보기"
// "vdcv.button.hide" = "숨기기"
// "vdcv.button.reveal" = "표시"
//
// labels
// "vdcv.label.category" = "카테고리: "
// "vdcv.label.languages" = "언어: "
//
// map
// "vdcv.text.signInToViewMap" = "지도를 보려면 로그인하세요."
//
// sections
// "vdcv.section.contact" = "연락처 및 외부 링크"
//
// contact
// "vdcv.contact.email" = "이메일"
// "vdcv.contact.phone" = "전화"
// "vdcv.contact.phoneWithCountry.format" = "전화 (%@)"
//
// accessibility
// "vdcv.a11y.signInRequired" = "로그인이 필요합니다"
//
// description view defaults
// "vdcv.desc.defaultTitle" = "설명 제목"
// "vdcv.desc.defaultBody" = "설명 내용이 여기에 표시됩니다"



// MARK: - VendorFilterSheetView (vfs)
// Source: VendorFilterSheetView.swift
//
// buttons
// "vfs.button.cancel" = "취소"
// "vfs.button.reset" = "초기화"
// "vfs.button.apply" = "적용"
//
// sections
// "vfs.section.location" = "위치"
// "vfs.section.language" = "언어"
//
// fields
// "vfs.field.country" = "국가"
// "vfs.field.city" = "도시"
// "vfs.field.district" = "구/군"
//
// preview
// "vfs.preview.tapToShow" = "탭하여 필터 시트를 표시"



// MARK: - HomeView (hv)
// Source: HomeView.swift
//
// titles
// "hv.title.main" = "메인"
// "hv.title.marks" = "마크"
// "hv.title.my" = "내 정보"
// "hv.title.profile" = "프로필"
//
// tabs
// "hv.tab.main" = "메인"
// "hv.tab.marks" = "마크"
// "hv.tab.my" = "내 정보"
// "hv.tab.profile" = "프로필"
//
// alerts
// "hv.alert.signInRequired.title" = "로그인이 필요합니다"
// "hv.alert.signInRequired.msg" = "마크를 보려면 로그인해주세요."
//
// buttons
// "hv.button.ok" = "OK"



// MARK: - AdminRoleDetailViewModel (ardvm)
// Source: AdminRoleDetailViewModel.swift
//
// templates
// "ardvm.tpl.ownershipAuthority.title" = "소유/권한 증빙이 부족합니다"
// "ardvm.tpl.ownershipAuthority.text" = "해당 비즈니스를 대표할 권한이 있음을 확인할 수 없습니다."
// "ardvm.tpl.ownershipChannel.title" = "공식 채널을 확인할 수 없습니다"
// "ardvm.tpl.ownershipChannel.text" = "제출된 증빙으로 공식 채널 소유를 확인할 수 없습니다."
// "ardvm.tpl.identityUnclear.title" = "신청자 신원이 불명확합니다"
// "ardvm.tpl.identityUnclear.text" = "신청자의 신원이 사업 대표자와 일치하는지 확인할 수 없습니다."
// "ardvm.tpl.policyIssue.title" = "정책 관련 이슈"
// "ardvm.tpl.policyIssue.text" = "신청이 플랫폼 정책 요건을 충족하지 않습니다."
// "ardvm.tpl.other.title" = "기타"
// "ardvm.tpl.other.text" = "현재로서는 신청을 승인할 수 없습니다."
//
// alerts
// "ardvm.alert.error.title" = "오류"
// "ardvm.alert.appNotFound.msg" = "신청을 찾을 수 없습니다."
// "ardvm.alert.notAllowed.title" = "허용되지 않음"
// "ardvm.alert.notAllowed.statusNotUpdatable.msg" = "이 신청은 업데이트할 수 없는 상태입니다."
// "ardvm.alert.notAllowed.notActionable.msg" = "이 신청은 처리할 수 없습니다."
// "ardvm.alert.missingConfirmations.title" = "확인 항목 누락"
// "ardvm.alert.missingConfirmations.msg" = "신청자 확인 항목이 완료되지 않았습니다."
// "ardvm.alert.missingEvidence.title" = "증빙 누락"
// "ardvm.alert.missingEvidence.msg" = "제출된 증빙이 없습니다."
// "ardvm.alert.evidenceNotVerified.title" = "증빙 미확인"
// "ardvm.alert.evidenceNotVerified.msg" = "승인하려면 모든 증빙 항목이 '확인됨' 상태여야 합니다."
// "ardvm.alert.approvedButRoleUpdateFailed.msg" = "승인했지만 사용자 역할 업데이트에 실패했습니다. 다시 시도해주세요."
// "ardvm.alert.missingTemplate.title" = "템플릿 누락"
// "ardvm.alert.missingTemplate.msg" = "거절 템플릿을 선택해주세요."
// "ardvm.alert.evidenceNotFound.msg" = "증빙을 찾을 수 없습니다."
// "ardvm.alert.adminPermissionRequired.msg" = "관리자 권한이 필요합니다."
// "ardvm.alert.invalidSession.title" = "세션이 유효하지 않습니다"
// "ardvm.alert.invalidSession.msg" = "리뷰하려면 인증이 필요합니다."



// MARK: - AdminRoleViewModel (arvm)
// Source: AdminRoleViewModel.swift
//
// filters
// "arvm.filter.all" = "전체"
// "arvm.filter.codePost" = "코드 게시"
// "arvm.filter.officialEmail" = "공식 이메일"



// MARK: - AdminStatusDetailViewModel (asdm)
// Source: AdminStatusDetailViewModel.swift
//
// alerts
// "asdm.alert.permissionDenied.title" = "권한 없음"
// "asdm.alert.permissionDenied.msg" = "관리자만 접근할 수 있습니다. 관리자 계정으로 로그인한 뒤 다시 시도해주세요."
// "asdm.alert.warning.title" = "경고"
// "asdm.alert.refreshSummaryFailed.msg" = "벤더 요약을 갱신하지 못했습니다."
// "asdm.alert.loadDetailFailed.msg" = "벤더 상세를 불러오지 못했습니다."
// "asdm.alert.loadImagesFailed.msg" = "벤더 이미지를 불러오지 못했습니다."
//
// rejection
// "asdm.rejection.fallback" = "거절됨"
//
// rejection categories
// "asdm.rejectCategory.content" = "콘텐츠 이슈"
// "asdm.rejectCategory.metadata" = "리스트/라벨 이슈"
// "asdm.rejectCategory.policy" = "정책 위반"
// "asdm.rejectCategory.manual" = "#MANUAL INPUT#"
//
// rejection templates (display)
// "asdm.rejectTpl.other" = "기타"
// "asdm.rejectTpl.inappropriateContent" = "부적절하거나 오해 소지 있는 콘텐츠"
// "asdm.rejectTpl.duplicateListing" = "중복 등록"
// "asdm.rejectTpl.invalidContact" = "연락처 정보가 유효하지 않음"
// "asdm.rejectTpl.rightsUnclear" = "이미지/포트폴리오 권리 불명확"
// "asdm.rejectTpl.missingRequiredInfo" = "필수 정보 누락"
// "asdm.rejectTpl.policyViolation" = "정책 위반"
// "asdm.rejectTpl.outOfScopeService" = "지원 범위 외 서비스"
// "asdm.rejectTpl.unsupportedRegion" = "지원하지 않는 지역"
// "asdm.rejectTpl.cannotVerifyBusiness" = "비즈니스 정당성 확인 불가"
// "asdm.rejectTpl.misleadingInfo" = "오해 소지 또는 잘못된 정보"
// "asdm.rejectTpl.spamOrPromotion" = "스팸 또는 과도한 홍보"
// "asdm.rejectTpl.lowQualityAssets" = "저품질 미디어/콘텐츠"
// "asdm.rejectTpl.languageUnsupported" = "지원하지 않는 언어"
// "asdm.rejectTpl.translationIssue" = "번역 이슈"
// "asdm.rejectTpl.conflictingOwnershipClaim" = "소유권 주장 충돌"
//
// rejection previews
// "asdm.rejectPreview.inappropriateContent" = "제출된 콘텐츠가 부적절하거나 오해 소지가 있어 보입니다."
// "asdm.rejectPreview.duplicateListing" = "이 벤더는 기존 등록과 중복된 것으로 보입니다."
// "asdm.rejectPreview.invalidContact" = "제공된 연락처 정보가 유효하지 않거나 확인할 수 없습니다."
// "asdm.rejectPreview.rightsUnclear" = "제출된 이미지/포트폴리오에 대한 권리를 확인할 수 없습니다."
// "asdm.rejectPreview.missingRequiredInfo" = "필수 정보가 누락되었거나 검토하기에 너무 모호합니다."
// "asdm.rejectPreview.policyViolation" = "이 요청은 플랫폼 정책을 위반합니다."
// "asdm.rejectPreview.outOfScopeService" = "제공 서비스가 이 플랫폼의 지원 범위를 벗어납니다."
// "asdm.rejectPreview.unsupportedRegion" = "벤더 위치가 지원하지 않거나 제한된 지역입니다."
// "asdm.rejectPreview.cannotVerifyBusiness" = "비즈니스의 정당성을 확인할 수 없습니다."
// "asdm.rejectPreview.misleadingInfo" = "제공된 정보가 오해 소지가 있거나 잘못되었거나 일관되지 않습니다."
// "asdm.rejectPreview.spamOrPromotion" = "제출 내용이 스팸이거나 과도한 홍보로 보입니다."
// "asdm.rejectPreview.lowQualityAssets" = "미디어 또는 콘텐츠 품질이 플랫폼 기준에 미치지 못합니다."
// "asdm.rejectPreview.languageUnsupported" = "제출된 언어는 현재 지원되지 않습니다."
// "asdm.rejectPreview.translationIssue" = "콘텐츠에 번역 또는 로컬라이제이션 이슈가 있습니다."
// "asdm.rejectPreview.conflictingOwnershipClaim" = "콘텐츠 소유권 주장에 충돌이 있습니다."



// MARK: - AdminStatusViewModel (asvm)
// Source: AdminStatusViewModel.swift
//
// alerts
// "asvm.alert.permissionDenied.title" = "권한 없음"
// "asvm.alert.permissionDenied.msg" = "관리자만 접근할 수 있습니다. 관리자 계정으로 로그인한 뒤 다시 시도해주세요."



// MARK: - AdminVendorDetailViewModel (avdvm)
// Source: AdminVendorDetailViewModel.swift
//
// messages
// "avdvm.message.warning.title" = "경고"
// "avdvm.message.refreshSummaryFailed.msg" = "벤더 요약을 갱신하지 못했습니다."
// "avdvm.message.loadDetailFailed.msg" = "벤더 상세를 불러오지 못했습니다."
// "avdvm.message.loadImagesFailed.msg" = "벤더 이미지를 불러오지 못했습니다."
// "avdvm.message.updated.title" = "업데이트됨"
// "avdvm.message.statusChanged.format" = "벤더 상태가 %@로 변경되었습니다."
//
// alerts
// "avdvm.alert.error.title" = "오류"
// "avdvm.alert.sessionExpired.msg" = "세션이 만료되었습니다. 다시 로그인해주세요."
// "avdvm.alert.permissionDenied.title" = "권한 없음"
// "avdvm.alert.onlyAdminCanChangeStatus.msg" = "관리자만 벤더 상태를 변경할 수 있습니다."
// "avdvm.alert.failed.title" = "실패"
// "avdvm.alert.changeStatusFailed.msg" = "벤더 상태를 변경할 수 없습니다."



// MARK: - AdminVendorViewModel (avvm)
// Source: AdminVendorViewModel.swift
//
// alerts
// "avvm.alert.error.title" = "오류"
// "avvm.alert.loadFailed.msg" = "벤더를 불러오지 못했습니다. 다시 시도해주세요."



// MARK: - AdminPortalView (apv)
// Source: AdminPortalView.swift
//
// title
// "apv.title.adminPortal" = "관리자 포털"
//
// sections
// "apv.section.accountInfo" = "계정 정보"
//
// user
// "apv.user.format" = "사용자: %@"
// "apv.user.roleApplicationCount" = "역할 신청 수: ??"
// "apv.user.pendingVendorCount" = "대기 중 벤더 수: ??"
//
// actions
// "apv.action.manageVendors.title" = "벤더 관리"
// "apv.action.manageVendors.subtitle" = "벤더 목록 보기"
// "apv.action.reviewRoles.title" = "역할 신청 검토"
// "apv.action.reviewRoles.subtitle" = "역할 신청 승인"
// "apv.action.reviewVendors.title" = "대기 벤더 검토"
// "apv.action.reviewVendors.subtitle" = "대기 벤더 승인"
//
// buttons
// "apv.button.ok" = "OK"



// MARK: - AdminRoleDetailView (ardv)
// Source: AdminRoleDetailView.swift
//
// title
// "ardv.title.roleAppDetail" = "역할 신청 상세"
//
// sections
// "ardv.section.status" = "상태"
// "ardv.section.applicantDetail" = "신청자 정보"
// "ardv.section.businessDetail" = "비즈니스 정보"
// "ardv.section.application" = "신청"
// "ardv.section.evidence" = "증빙"
// "ardv.section.terms" = "약관"
// "ardv.section.decision" = "결정"
// "ardv.section.actions" = "액션"
// "ardv.reject.section.preview" = "미리보기"
//
// texts
// "ardv.text.appNotFound" = "신청을 찾을 수 없습니다."
// "ardv.text.noActions" = "이 신청에 사용할 수 있는 액션이 없습니다."
// "ardv.reject.text.noTemplates" = "사용 가능한 템플릿이 없습니다."
// "ardv.reject.text.selectTemplateHint" = "거절 템플릿을 선택해 미리보기하세요."
//
// fields
// "ardv.field.name" = "이름"
// "ardv.field.roleTitle" = "역할/직함"
// "ardv.field.email" = "이메일"
// "ardv.field.phone" = "전화"
// "ardv.field.authorityConfirmed" = "권한 확인"
// "ardv.field.rightsConfirmed" = "권리 확인"
// "ardv.field.brandName" = "브랜드/사업명"
// "ardv.field.category" = "카테고리"
// "ardv.field.currentRole" = "현재 역할"
// "ardv.field.requestedRole" = "요청 역할"
// "ardv.field.termsVersion" = "약관 버전"
// "ardv.field.agreedAt" = "동의 시각"
// "ardv.field.result" = "결과"
// "ardv.field.reviewer" = "검토자"
// "ardv.field.decidedAt" = "결정 시각"
// "ardv.field.rejectionCategory" = "카테고리"
//
// common buttons
// "ardv.button.cancel" = "취소"
// "ardv.button.confirm" = "확인"
// "ardv.button.reject" = "거절"
// "ardv.button.approve" = "승인"
//
// toasts
// "ardv.toast.needLogin" = "로그인이 필요합니다"
// "ardv.toast.copied" = "복사했습니다."
//
// approve/reject sheet
// "ardv.reject.title" = "역할 신청 거절"
// "ardv.reject.field.category" = "카테고리"
// "ardv.reject.field.template" = "템플릿"
// "ardv.reject.placeholder.detailOptional" = "상세(선택)"
// "ardv.approve.title" = "신청 승인"
//
// evidence
// "ardv.evidence.method.officialEmail" = "공식 이메일"
// "ardv.evidence.method.codePost" = "코드 게시"
// "ardv.evidence.submittedAt.format" = "제출: %@"
// "ardv.evidence.field.email" = "이메일"
// "ardv.evidence.field.url" = "URL"
// "ardv.evidence.field.code" = "코드"
// "ardv.evidence.button.verified" = "증빙 확인됨"
// "ardv.evidence.alert.verify.title" = "증빙을 확인할까요?"
// "ardv.evidence.alert.verify.msg" = "이 증빙을 '확인됨'으로 표시합니다."



// MARK: - AdminRoleView (arv)
// Source: AdminRoleView.swift
//
// navigation
// "arv.nav.title" = "역할 신청"
//
// tabs
// "arv.tab.pending" = "대기"
// "arv.tab.history" = "내역"
//
// header
// "arv.header.subtitle" = "벤더 역할 신청을 검토하세요"
//
// buttons
// "arv.button.ok" = "OK"
//
// empty
// "arv.empty.pending" = "대기 중인 신청이 없습니다."
// "arv.empty.history" = "아직 내역이 없습니다."
// "arv.empty.hint" = "사용자가 요청을 제출하면 여기에 표시됩니다."
//
// row
// "arv.row.noBrand" = "(브랜드명 없음)"
// "arv.row.applicant.format" = "신청자: %@"
// "arv.row.method.format" = "방식: %@"
// "arv.row.method.unknown" = "알 수 없음"



// MARK: - AdminStatusDetailView (asdv)
// Source: AdminStatusDetailView.swift
//
// navigation
// "asdv.nav.title" = "검토"
//
// titles
// "asdv.title.applicationDetail" = "신청 상세"
//
// sections
// "asdv.section.commentFromVendor" = "벤더 코멘트"
// "asdv.section.actions" = "액션"
//
// fields
// "asdv.field.request" = "요청"
// "asdv.field.decision" = "결정"
// "asdv.field.vendorId" = "벤더 ID"
// "asdv.field.applicantUserId" = "신청자 User ID"
// "asdv.field.termsVersion" = "약관 버전"
// "asdv.field.agreedAt" = "동의 시각"
// "asdv.field.created" = "생성"
// "asdv.field.updated" = "수정"
//
// buttons
// "asdv.button.ok" = "OK"
// "asdv.button.cancel" = "취소"
// "asdv.button.reject" = "거절"
// "asdv.button.approve" = "승인"
// "asdv.button.showReviewScreen" = "리뷰 화면 보기"
//
// texts
// "asdv.text.alreadyDecided.format" = "이 신청은 이미 %@ 처리되었습니다."
//
// toasts
// "asdv.toast.copiedVendorId" = "VendorID를 복사했습니다."
// "asdv.toast.copiedUserId" = "UserID를 복사했습니다."
//
// alerts
// "asdv.alert.invalidPath.title" = "이 화면을 열 수 없습니다"
// "asdv.alert.invalidPath.msg" = "접근 경로가 올바르지 않거나 필요한 데이터가 없습니다."
// "asdv.alert.error.title" = "오류"
// "asdv.alert.approveFailed.msg" = "승인에 실패했습니다."
// "asdv.alert.rejectFailed.msg" = "거절에 실패했습니다."
//
// approve/reject sheet
// "asdv.reject.title.format" = "%@ 요청 거절"
// "asdv.reject.field.category" = "카테고리"
// "asdv.reject.field.template" = "템플릿"
// "asdv.reject.section.preview" = "미리보기"
// "asdv.reject.placeholder.detailOptional" = "상세(선택)"
// "asdv.reject.hint.appended" = "이 메모는 거절 사유에 추가됩니다."
// "asdv.approve.title.format" = "%@ 요청 승인"



// MARK: - AdminStatusView (asv)
// Source: AdminStatusView.swift
//
// navigation
// "asv.nav.title" = "상태 검토"
//
// tabs
// "asv.tab.pending" = "대기"
// "asv.tab.history" = "내역"
//
// header
// "asv.header.title" = "상태 신청"
// "asv.header.countPending.format" = "%d건 대기"
// "asv.header.countHistory.format" = "%d건 내역"
//
// menu
// "asv.menu.requestType" = "요청 유형"
// "asv.menu.decision" = "결정"
// "asv.menu.all" = "전체"
//
// buttons
// "asv.button.ok" = "OK"
//
// empty
// "asv.empty.pending.title" = "대기 중인 신청이 없습니다"
// "asv.empty.pending.subtitle" = "일시적인 네트워크 오류일 수 있습니다. 잠시 후 다시 시도해주세요."
// "asv.empty.history.title" = "내역이 없습니다"
// "asv.empty.history.subtitle" = "승인/거절/취소 결과가 여기에 표시됩니다."
//
// sections
// "asv.section.actionRequired" = "조치 필요"
// "asv.section.history" = "내역"
//
// filters
// "asv.filter.all" = "전체"
//
// row
// "asv.row.vendorId.format" = "벤더 ID: %@"
// "asv.row.applicantId.format" = "신청자 ID: %@"
// "asv.row.terms.format" = "약관: %@"



// MARK: - AdminVendorDetailView (avdv)
// Source: AdminVendorDetailView.swift
//
// menu
// "avdv.menu.copyVendorId" = "벤더 ID 복사"
// "avdv.menu.changeStatus" = "상태 변경"
//
// sections
// "avdv.section.status" = "상태"
//
// buttons
// "avdv.button.cancel" = "취소"
// "avdv.button.apply" = "적용"
// "avdv.button.confirm" = "확인"
// "avdv.button.open" = "열기"
// "avdv.button.ok" = "OK"
//
// alerts
// "avdv.alert.confirmChange.title" = "변경 확인"
// "avdv.alert.confirmChange.format" = "'%@'을(를) '%@'(으)로 변경할까요?"
// "avdv.alert.openExternal.title" = "외부 링크를 열까요?"
//
// toasts
// "avdv.toast.copied" = "복사했습니다."



// MARK: - AdminVendorView (avv)
// Source: AdminVendorView.swift
//
// filters
// "avv.filter.status.all" = "전체"
//
// search
// "avv.search.prompt" = "검색"
//
// buttons
// "avv.button.ok" = "OK"
