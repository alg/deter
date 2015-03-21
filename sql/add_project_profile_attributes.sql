-- Adds missing project profile attributes

INSERT INTO projectattribute (name, datatype, optional, access, description, sequence, length) VALUES
  ("website", "STRING", 1, "READ_WRITE", "Project Web Site", 100, 0),
  ("org_type", "STRING", 1, "READ_WRITE", "Project Organization Type", 200, 0),
  ("research_focus", "STRING", 1, "READ_WRITE", "Project Research Focus", 300, 0),
  ("funding", "STRING", 1, "READ_WRITE", "Project Funding or Support", 400, 0),
  ("listing", "STRING", 1, "READ_WRITE", "Project Listing", 500, 0);
  
