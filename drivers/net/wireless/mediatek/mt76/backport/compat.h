// Fix <v5.17 nominal typo
#ifndef IEEE80211_HE_PHY_CAP9_NOMINAL_PKT_PADDING_16US
#define IEEE80211_HE_PHY_CAP9_NOMINAL_PKT_PADDING_16US IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_16US
#endif

// 0fb9387b8584c0228f4088bcdfaec056162297cd got into 5.15 but not .16 & .17
#ifndef IEEE80211_MAX_AMPDU_BUF_HE
#define IEEE80211_MAX_AMPDU_BUF_HE 0x100
#endif

// 75d4f92d8788e7df3ff864e0ba42bb4d1bcd6eda git into 5.15 but not .16
#ifndef SYSTEM_SLEEP_PM_OPS
#define SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
	.suspend = pm_sleep_ptr(suspend_fn), \
	.resume = pm_sleep_ptr(resume_fn), \
	.freeze = pm_sleep_ptr(suspend_fn), \
	.thaw = pm_sleep_ptr(resume_fn), \
	.poweroff = pm_sleep_ptr(suspend_fn), \
	.restore = pm_sleep_ptr(resume_fn),
#endif

#ifndef DEFINE_SIMPLE_DEV_PM_OPS
#define DEFINE_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
const struct dev_pm_ops name = { \
	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
}
#endif

#ifndef pm_sleep_ptr
#define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
#endif
