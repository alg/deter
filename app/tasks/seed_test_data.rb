class SeedTestData

  PROJECT_DEFAULTS = {
    website:         'http://uso.edu/research',
    org_type:        'Academic',
    research_focus:  'Malware',
    funding:         'Academic Institution Support',
    listing:         true
  }

  PROJECTS = {
    'Alfa-Romeo' => { description: 'Study the speed of malware spread in a closed environment.' },
    'Beta-Test'  => { description: 'Measure the effectiveness bot-net C&C surveillance.' },
    'Gamma-Ray'  => { description: 'Experiment with new methods of network based malware detection.' }
  }

  USER_DEFAULTS = {
    phone:               '301/123-4567',
    title:               'Research Staff',
    affiliation:         'University of South Otago',
    affiliation_abbrev:  'USO',
    URL:                 'http://uso.edu',
    address1:            '123 Main St.',
    address2:            '',
    city:                'South Ontago',
    state:               'Farallon',
    zip:                 '12345',
    country:             'US'
  }

  USERS = [
    { name: 'Abigail Adams',    email: 'aadams@uso.edu',          password: 'Abigail',   owns_projects: [ 'Alfa-Romeo' ]  },
    { name: 'Arthur Ashe',      email: 'aashe@uso.edu',           password: 'Arthur',    owns_projects: [] },
    { name: 'Ambrose Bierce',   email: 'abierce@uso.edu',         password: 'Ambrose',   owns_projects: [] },
    { name: 'Buzzby Berkley',   email: 'bberkley@uso.edu',        password: 'Buzzby',    owns_projects: [ 'Beta-Test' ] },
    { name: 'Britt Greer',      email: 'bgreer@uso.edu',          password: 'Britt',     owns_projects: [] },
    { name: 'Gerta Grein',      email: 'ggrein@uso.edu',          password: 'Gerta',     owns_projects: [ 'Gamma-Ray' ] },
    { name: 'John Sebes',       email: 'john@sebes.com',          password: 'John',      owns_projects: [] },
    { name: 'Aleksey Gureiev',  email: 'spyromus@noizeramp.com',  password: 'Aleksey',   owns_projects: [] }
  ]

  PROJECT_USERS = {
    'Alfa-Romeo' => [ 'Arthur Ashe', 'Ambrose Bierce' ],
    'Beta-Test'  => [ 'Abigail Adams', 'Ambrose Bierce', 'Britt Greer', 'John Sebes', 'Aleksey Gureiev' ],
    'Gamma-Ray'  => [ 'Abigail Adams', 'Britt Greer' ],
    'admin'      => [ 'John Sebes', 'Aleksey Gureiev' ]
  }

  PROJECT_PROFILE_ATTRS = [
    { name: "website",         type: "STRING",  optional: true,  access: "READ_WRITE",  description: "Project Web Site",            sequence: 100,  value: 0 },
    { name: "org_type",        type: "STRING",  optional: true,  access: "READ_WRITE",  description: "Project Organization Type",   sequence: 200,  value: 0 },
    { name: "research_focus",  type: "STRING",  optional: true,  access: "READ_WRITE",  description: "Project Research Focus",      sequence: 300,  value: 0 },
    { name: "funding",         type: "STRING",  optional: true,  access: "READ_WRITE",  description: "Project Funding or Support",  sequence: 400,  value: 0 },
    { name: "listing",         type: "STRING",  optional: true,  access: "READ_WRITE",  description: "Project Listing",             sequence: 500,  value: 0 }
  ]

  USER_EXPERIMENTS = {
    'Abigail Adams' => [
      { name: 'HelloWorld', project: 'Alfa-Romeo' }
    ],
    'Ambrose Bierce' => [
      { name: 'ExperimentOne', project: 'Alfa-Romeo', aspects: [
          { type:   "layout",
            data:   "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxleHBlcmltZW50PgogPHZlcnNpb24+MS4wPC92ZXJzaW9uPgogPHN1YnN0cmF0ZXM+CiAgPG5hbWU+bGluazI8L25hbWU+CiAgPGNhcGFjaXR5PgogICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICA8a2luZD5tYXg8L2tpbmQ+CiAgPC9jYXBhY2l0eT4KIDwvc3Vic3RyYXRlcz4KIDxzdWJzdHJhdGVzPgogIDxuYW1lPmxpbmswPC9uYW1lPgogIDxjYXBhY2l0eT4KICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgPGtpbmQ+bWF4PC9raW5kPgogIDwvY2FwYWNpdHk+CiA8L3N1YnN0cmF0ZXM+CiA8c3Vic3RyYXRlcz4KICA8bmFtZT5saW5rMTwvbmFtZT4KICA8Y2FwYWNpdHk+CiAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgIDxraW5kPm1heDwva2luZD4KICA8L2NhcGFjaXR5PgogPC9zdWJzdHJhdGVzPgogPGVsZW1lbnRzPgogIDxjb21wdXRlcj4KICAgPG5hbWU+ZDwvbmFtZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazI8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMDwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50eXBlPC9hdHRyaWJ1dGU+" +
                    "CiAgICA8dmFsdWU+cGM8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dGVzdGJlZDwvYXR0cmlidXRlPgogICAgPHZhbHVlPmRldGVyPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPmZhaWx1cmVhY3Rpb248L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5mYXRhbDwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogIDwvY29tcHV0ZXI+CiA8L2VsZW1lbnRzPgogPGVsZW1lbnRzPgogIDxjb21wdXRlcj4KICAgPG5hbWU+YTwvbmFtZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazA8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMDwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50eXBlPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+cGM8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dGVzdGJlZDwvYXR0cmlidXRlPgogICAgPHZhbHVlPmRlc2t0b3A8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+ZmFpbHVyZWFjdGlvbjwvYXR0cmlidXRlPgogICAgPHZhbHVlPmZhdGFsPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgPC9jb21wdXRlcj4KIDwvZWxlbWVudHM+" +
                    "CiA8ZWxlbWVudHM+CiAgPGNvbXB1dGVyPgogICA8bmFtZT5iPC9uYW1lPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMDwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAwPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmsxPC9zdWJzdHJhdGU+CiAgICA8bmFtZT5pbmYwMDE8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dHlwZTwvYXR0cmlidXRlPgogICAgPHZhbHVlPnBjPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPnRlc3RiZWQ8L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5kZXRlcjwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT5mYWlsdXJlYWN0aW9uPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZmF0YWw8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICA8L2NvbXB1dGVyPgogPC9lbGVtZW50cz4KIDxlbGVtZW50cz4KICA8Y29tcHV0ZXI+CiAgIDxuYW1lPmM8L25hbWU+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmsyPC9zdWJzdHJhdGU+" +
                    "CiAgICA8bmFtZT5pbmYwMDA8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazE8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMTwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50eXBlPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+cGM8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dGVzdGJlZDwvYXR0cmlidXRlPgogICAgPHZhbHVlPmRldGVyPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPmZhaWx1cmVhY3Rpb248L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5mYXRhbDwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogIDwvY29tcHV0ZXI+CiA8L2VsZW1lbnRzPgogPGVsZW1lbnRzPgogIDxyZWdpb24+CiAgICA8bmFtZT5SPC9uYW1lPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMjwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAwPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+" +
                    "bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmsxPC9zdWJzdHJhdGU+CiAgICA8bmFtZT5pbmYwMDE8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgIDxsZXZlbD4yPC9sZXZlbD4KICAgIDxmcmFnbmFtZT5mcmFnbWVudDE8L2ZyYWduYW1lPgogIDwvcmVnaW9uPgogPC9lbGVtZW50cz4KIDxmcmFnbWVudHM+CiAgIDxuYW1lPmZyYWdtZW50MTwvbmFtZT4KICA8dG9wb2xvZ3k+CiA8c3Vic3RyYXRlcz4KICA8bmFtZT5saW5rMjwvbmFtZT4KICA8Y2FwYWNpdHk+CiAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgIDxraW5kPm1heDwva2luZD4KICA8L2NhcGFjaXR5PgogPC9zdWJzdHJhdGVzPgogPHN1YnN0cmF0ZXM+CiAgPG5hbWU+bGluazA8L25hbWU+CiAgPGNhcGFjaXR5PgogICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICA8a2luZD5tYXg8L2tpbmQ+CiAgPC9jYXBhY2l0eT4KIDwvc3Vic3RyYXRlcz4KIDxzdWJzdHJhdGVzPgogIDxuYW1lPmxpbmsxPC9uYW1lPgogIDxjYXBhY2l0eT4KICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgPGtpbmQ+bWF4PC9raW5kPgogIDwvY2FwYWNpdHk+CiA8L3N1YnN0cmF0ZXM+CiA8ZWxlbWVudHM+" +
                    "CiAgPGNvbXB1dGVyPgogICA8bmFtZT5kPC9uYW1lPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMjwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAwPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPnR5cGU8L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5wYzwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50ZXN0YmVkPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZGV0ZXI8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+ZmFpbHVyZWFjdGlvbjwvYXR0cmlidXRlPgogICAgPHZhbHVlPmZhdGFsPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgPC9jb21wdXRlcj4KIDwvZWxlbWVudHM+CiA8ZWxlbWVudHM+CiAgPGNvbXB1dGVyPgogICA8bmFtZT5hPC9uYW1lPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMDwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAwPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxhdHRyaWJ1dGU+" +
                    "CiAgICA8YXR0cmlidXRlPnR5cGU8L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5wYzwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50ZXN0YmVkPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZGVza3RvcDwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT5mYWlsdXJlYWN0aW9uPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZmF0YWw8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICA8L2NvbXB1dGVyPgogPC9lbGVtZW50cz4KIDxlbGVtZW50cz4KICA8Y29tcHV0ZXI+CiAgIDxuYW1lPmI8L25hbWU+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmswPC9zdWJzdHJhdGU+CiAgICA8bmFtZT5pbmYwMDA8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazE8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMTwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50eXBlPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+" +
                    "cGM8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dGVzdGJlZDwvYXR0cmlidXRlPgogICAgPHZhbHVlPmRldGVyPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPmZhaWx1cmVhY3Rpb248L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5mYXRhbDwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogIDwvY29tcHV0ZXI+CiA8L2VsZW1lbnRzPgogPGVsZW1lbnRzPgogIDxjb21wdXRlcj4KICAgPG5hbWU+YzwvbmFtZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazI8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMDwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMTwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAxPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPnR5cGU8L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5wYzwvdmFsdWU+" +
                    "CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50ZXN0YmVkPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZGV0ZXI8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+ZmFpbHVyZWFjdGlvbjwvYXR0cmlidXRlPgogICAgPHZhbHVlPmZhdGFsPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiA8L2NvbXB1dGVyPgo8L2VsZW1lbnRzPgo8ZWxlbWVudHM+CiAgPHJlZ2lvbj4KICAgIDxuYW1lPlI8L25hbWU+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmsyPC9zdWJzdHJhdGU+CiAgICA8bmFtZT5pbmYwMDA8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazE8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMTwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICAgPGxldmVsPjI8L2xldmVsPgogICAgPGZyYWduYW1lPmZyYWdtZW50MTwvZnJhZ25hbWU+CiAgPC9yZWdpb24+CjwvZWxlbWVudHM+CjwvdG9wb2xvZ3k+" +
                    "CjxpZm1hcD48aW5uZXI+YTwvaW5uZXI+PG91dGVyPmluZjAwMDwvb3V0ZXI+PC9pZm1hcD4KPGlmbWFwPjxpbm5lcj5kPC9pbm5lcj48b3V0ZXI+aW5mMDAxPC9vdXRlcj48L2lmbWFwPgo8L2ZyYWdtZW50cz4KPC9leHBlcmltZW50Pgo=",
            cc_url: "https://gist.githubusercontent.com/alg/f5e024268f7dd37744e1/raw/7118814662145937968e13c0ef95abb08be528d5/layout.xml" },
          { type:   "visualization",
            data:   Base64.encode64("http://tau.isi.edu/magi-viz/smartamerica/CA/") },
          { type:   "orchestration",
            data:   Base64.encode64("AAL TBD") }
        ]
      }
    ],
    'Buzzby Berkley' => [
      { name: 'Beta-Dyne', project: 'Beta-Test' },
      { name: 'Beta-Zed', project: 'Beta-Test' }
    ],
    'Britt Greer' => [
      { name: 'Gamma-Exp', project: 'Gamma-Ray' }
    ]
  }

  LIBRARIES = [
    { name: 'MainLibrary',       owner: 'John Sebes',    experiments: [ 'HelloWorld1', 'HelloWorld2' ] },
    { name: 'AlexandriaLibrary', owner: 'Abigail Adams', experiments: [ 'HelloAlexandria' ] }
  ]

  def initialize(admin_user, admin_pass)
    @admin_user = admin_user
    @admin_pass = admin_pass
    @user_ids = {}
  end

  def perform
    unless login
      raise "Invalid admin credentials. Set ADMIN_USERNAME and ADMIN_PASSWORD env variables."
    end

    ensure_project_profile_attributes

    puts "Creating users and projects:"
    USERS.each { |u| create_user(u) }

    puts "Joining projects:"
    PROJECT_USERS.each { |project_id, users| join_project(project_id, users) }

    puts "Creating experiments:"
    USER_EXPERIMENTS.each { |user_name, experiments| create_experiments(@user_ids[user_name], user_name.split(' ')[0], experiments) }

    puts "Creating requests:"
    create_requests

    puts "Creating libraries:"
    create_libraries

    return {
      user_ids: @user_ids
    }
  end

  def ensure_project_profile_attributes
    puts "Checking project profile attributes"
    attrs = DeterLab.get_project_profile_description
    present_attrs = attrs.map(&:name)

    PROJECT_PROFILE_ATTRS.each do |attr|
      next if present_attrs.include?(attr[:name])

      DeterLab.create_project_attribute(@admin_user, attr[:name], attr[:type], attr[:optional], attr[:access], attr[:description], attr[:sequence])
      puts "  - New project attribute: #{attr.inspect}"
    end
  end

  private

  # attempts to login and returns true / false
  def login
    puts "Logging in as #{@admin_user}"
    DeterLab.valid_credentials?(@admin_user, @admin_pass)
  end

  def create_user(up)
    user_id = DeterLab.create_user_no_confirm(@admin_user, up[:password], USER_DEFAULTS.merge(name: up[:name], email: up[:email]))
    puts "  - New user #{up[:name]} (#{user_id})"
    @user_ids[up[:name]] = user_id

    ActivityLog.for_user(user_id).add(:create, @admin_user)

    up[:owns_projects].each do |project_id|
      ActivityLog.for_project(project_id).clear
      pp = PROJECTS[project_id] or raise("Project attributes for #{project_id} not found")
      puts "  - New project #{project_id} for #{user_id}"
      begin
        create_project(user_id, project_id, pp)
      rescue DeterLab::RequestError => e
        if e.message =~ /name conflict/
          DeterLab.remove_project(@admin_user, project_id)
          create_project(user_id, project_id, pp)
        else
          raise e
        end
      end
    end
  end

  def create_project(user_id, project_id, pp)
    DeterLab.create_project(@admin_user, project_id, user_id, PROJECT_DEFAULTS.merge(description: pp[:description]))
    DeterLab.approve_project(@admin_user, project_id)

    ActivityLog.for_project(project_id).add(:create, user_id)
  end

  def join_project(project_id, users)
    uids = users.map { |name| @user_ids[name] }
    DeterLab.add_users_no_confirm(@admin_user, project_id, uids, [ "ALL_PERMS" ])
    puts "  - Added users #{uids.inspect} to #{project_id}"

    uids.each do |uid|
      ActivityLog.for_project(project_id).add(:user_joined, uid)
    end
  end

  def create_experiments(user_id, password, experiments)
    DeterLab.valid_credentials?(user_id, password)
    experiments.each do |e|
      created = false
      eid = "#{e[:project]}:#{e[:name]}"
      ActivityLog.for_experiment(eid).clear
      begin
        DeterLab.create_experiment(user_id, e[:project], e[:name], { description: "Custom experiment" })
        created = true
      rescue DeterLab::RequestError => ex
        raise ex unless ex.message =~ /exists/
        DeterLab.remove_experiment(@admin_user, eid)
        DeterLab.create_experiment(user_id, e[:project], e[:name], { description: "Custom experiment" })
      end
      puts " - New experiment #{eid} by #{user_id}"

      if created
        log = ActivityLog.for_experiment(eid)
        log.add(:create, user_id)

        (e[:aspects] || []).each do |asp|
          puts "    - Adding #{asp[:type]} aspect"
          res = DeterLab.add_experiment_aspects(user_id, "#{e[:project]}:#{e[:name]}", [ { type: asp[:type], data: asp[:data] } ])

          log.add("new-aspect-#{asp[:type]}", user_id)

          if (cc_url = asp[:cc_url]).present?
            asp = ExperimentAspect.new(eid, res.first[0], :type, :sub_type, :raw_data, :data_reference)
            asp.last_updated_at        = Time.now
            asp.last_updated_by        = user_id
            asp.change_control_enabled = '1'
            asp.change_control_url     = cc_url
            puts "      with CC URL: #{cc_url}"
          end
        end
      end
    end
  end

  def create_requests
    # The following are unauthenticated requests (not made in the context of a user session)
    # * New account request for Dirk Pitt, dpitt@uso.edu, same other attributes as users above
    dirk = DeterLab.create_user(USER_DEFAULTS.merge(name: 'Dirk Pitt', email: 'dpitt@uso.edu'))

    ActivityLog.for_user(dirk).add(:create, nil)

    # * New project request with owner uid being that returned from the Dirk Pitt create-user call; project name Delta-Blues summary "Get down, get funky", same attributes as above projects
    ensure_create_project(dirk, "Delta-Blues", "Get down, get funky")
    puts "  - New project Delta-Blues request by Dirk Pitt (#{dirk})"

    # * New account request for Andreas Ackermann, aackermann@uso.edu, same other attributes as users above
    andreas = DeterLab.create_user(USER_DEFAULTS.merge(name: 'Andreas Ackermann', email: 'aackermann@uso.edu'))

    ActivityLog.for_user(andreas).add(:create, nil)

    # * Join project request with owner uid being that returned from the Andreas Ackermann create-user call; request to join project Alfa-Romeo
    DeterLab.join_project(andreas, 'Alfa-Romeo')
    puts "  - Project Alfa-Romeo join request by Andreas Ackermann (#{andreas})"

    # In addition, there should be a create-project request in a login session of Ambrose Bierce, to create a new project Devils-Dictionary "Compile a corpus of clever snark", same ofher project attributes as above.
    ambrose = @user_ids['Ambrose Bierce']
    DeterLab.valid_credentials?(ambrose, 'Ambrose')
    ensure_create_project(ambrose, "Devils-Dictionary", "Compile a corpus of clever snark")
    puts "  - New project Devils-Dictionary request by Ambrose Bierce (#{ambrose})"
  end

  def create_libraries
    LIBRARIES.each do |l|
      create_library(l)
    end
  end

  def create_library(l)
    owner_uid = @user_ids[l[:owner]]
    puts "  - #{owner_uid}:#{l[:name]}"

    password = l[:owner].split(' ')[0]
    experiment_ids = l[:experiments].map do |ename|
      DeterLab.create_experiment(@admin_user, owner_uid, ename, {
        description: "Library experiment",
        access_lists: [
          ExperimentACL.new('system:world', ExperimentACL::READ_EXPERIMENT),
          ExperimentACL.new("#{owner_uid}:#{owner_uid}", 'ALL_PERMS')
        ]
      }, owner_uid)

      eid = "#{owner_uid}:#{ename}"
      log = ActivityLog.for_experiment(eid)
      log.clear
      log.add(:create, owner_uid)

      eid
    end

    puts "    - Experiment IDs: #{experiment_ids.inspect}"

    lib_name = "#{owner_uid}:#{l[:name]}"
    DeterLab.create_library(@admin_user, lib_name, {
      access_lists: [
        LibraryMember.new("#{owner_uid}:#{owner_uid}", LibraryMember::ALL_PERMS),
        LibraryMember.new('system:world', [ LibraryMember::READ_LIBRARY ]),
      ],
      description:  "Seeded library"
    }, owner_uid)

    res = DeterLab.add_library_experiments(@admin_user, lib_name, experiment_ids)
    failed = res.select { |k, v| !v }.keys
    if !failed.empty?
      raise "Failed to add experiments #{failed.inspect} to the library #{lib_name}"
    end
  end

  def ensure_create_project(uid, pid, descr)
    begin
      DeterLab.create_project(uid, pid, uid, PROJECT_DEFAULTS.merge(description: descr))
    rescue DeterLab::RequestError => e
      if e.message =~ /name conflict/
        DeterLab.remove_project(@admin_user, pid)
        DeterLab.create_project(uid, pid, uid, PROJECT_DEFAULTS.merge(description: descr))
      else
        raise e
      end
    end

    ActivityLog.for_project(pid).add(:create, uid)
  end

end
