chrome.declarativeNetRequest.updateDynamicRules({
  removeRuleIds: [1, 2, 3, 4, 5, 6, 7],
  addRules: [
    {
      id: 1,
      priority: 1,
      action: {
        type: "redirect",
        redirect: {
          regexSubstitution: "http://localhost:5000/go/\\1",
        },
      },
      condition: {
        regexFilter: "^http://go/(.*)",
        resourceTypes: ["main_frame"],
      },
    },
    {
      id: 2,
      priority: 1,
      action: {
        type: "redirect",
        redirect: {
          url: "https://calendar.google.com",
        },
      },
      condition: {
        regexFilter: "^http://c/(.*)",
        resourceTypes: ["main_frame"],
      },
    },
    {
      id: 3,
      priority: 1,
      action: {
        type: "redirect",
        redirect: {
          url: "http://mail.google.com",
        },
      },
      condition: {
        regexFilter: "^http://m/(.*)",
        resourceTypes: ["main_frame"],
      },
    },
    {
      id: 4,
      priority: 1,
      action: {
        type: "redirect",
        redirect: {
          regexSubstitution: "https://github.com/\\1",
        },
      },
      condition: {
        regexFilter: "^http://gh/(.*)",
        resourceTypes: ["main_frame"],
      },
    },
    {
      id: 5,
      priority: 1,
      action: {
        type: "redirect",
        redirect: {
          regexSubstitution: "https://github.com/utdnebula/planner/\\1",
        },
      },
      condition: {
        regexFilter: "^http://p/(.*)",
        resourceTypes: ["main_frame"],
      },
    },
    {
      id: 6,
      priority: 1,
      action: {
        type: "redirect",
        redirect: {
		url: "https://drive.google.com",
        },
      },
      condition: {
        regexFilter: "^http://d/(.*)",
        resourceTypes: ["main_frame"],
      },
    },
    {
      id: 7,
      priority: 1,
      action: {
        type: "redirect",
        redirect: {
		url: "https://outlook.live.com/mail",
        },
      },
      condition: {
        regexFilter: "^http://o/(.*)",
        resourceTypes: ["main_frame"],
      },
    },
  ],
});
