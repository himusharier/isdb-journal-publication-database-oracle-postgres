-- Create the journals table
CREATE TABLE journals (
  journal_id SERIAL PRIMARY KEY,
  journal_name VARCHAR(200) NOT NULL,
  eissn_id VARCHAR(20) NOT NULL,
  publication_type VARCHAR(50) NOT NULL,
  impact_factor NUMERIC(5, 2),
  publication_frequency VARCHAR(20),
  acceptance_rate NUMERIC(5, 2)
);

-- Create the issues table
CREATE TABLE issues (
  journal_id INTEGER NOT NULL,
  vol_issue VARCHAR(50) NOT NULL,
  publish_date DATE,
  PRIMARY KEY (journal_id, vol_issue),
  CONSTRAINT issues_journal_id_fk_journals FOREIGN KEY (journal_id) REFERENCES journals (journal_id)
);

-- Create the announcements table
CREATE TABLE announcements (
  journal_id INTEGER NOT NULL,
  announcement_id SERIAL,
  topic VARCHAR(300),
  announcement VARCHAR(1000) NOT NULL,
  announce_date DATE NOT NULL,
  PRIMARY KEY (journal_id, announcement_id),
  CONSTRAINT announcements_journal_id_fk_journals FOREIGN KEY (journal_id) REFERENCES journals (journal_id)
);

-- Create the authors table
CREATE TABLE authors (
  user_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50),
  gender VARCHAR(10) NOT NULL CHECK (gender IN ('Male', 'Female', 'Others')),
  date_of_birth DATE,
  email VARCHAR(200) NOT NULL,
  phone VARCHAR(20),
  profession VARCHAR(50),
  institute VARCHAR(200),
  country VARCHAR(50),
  address VARCHAR(300)
);

-- Create the editorial table
CREATE TABLE editorial (
  journal_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  category VARCHAR(50) NOT NULL,
  PRIMARY KEY (journal_id, user_id),
  CONSTRAINT editorial_journal_id_fk_journals FOREIGN KEY (journal_id) REFERENCES journals (journal_id),
  CONSTRAINT editorial_user_id_fk_authors FOREIGN KEY (user_id) REFERENCES authors (user_id)
);

-- Create the articles table
CREATE TABLE articles (
  journal_id INTEGER NOT NULL,
  article_id SERIAL PRIMARY KEY, 
  vol_issue VARCHAR(20) NOT NULL,
  article_title VARCHAR(300) NOT NULL,
  abstract VARCHAR(1000) NOT NULL,
  article_type VARCHAR(50) NOT NULL,
  keywords VARCHAR(200),
  doi_id VARCHAR(100),
  author INTEGER NOT NULL,
  corresponding_author INTEGER,
  published_date DATE NOT NULL,
  CONSTRAINT articles_journal_id_vol_issue_fk_issues FOREIGN KEY (journal_id, vol_issue) REFERENCES issues (journal_id, vol_issue),
  CONSTRAINT articles_author_fk_authors FOREIGN KEY (author) REFERENCES authors (user_id),
  CONSTRAINT articles_corresponding_author_fk_authors FOREIGN KEY (corresponding_author) REFERENCES authors (user_id)
);
