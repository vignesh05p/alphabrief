-- =====================================================
-- DATABASE CREATION
-- =====================================================

CREATE DATABASE IF NOT EXISTS alphabrief_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE alphabrief_db;

-- =====================================================
-- APPLICATION USER
-- =====================================================

CREATE USER IF NOT EXISTS 'alphabrief'@'%' IDENTIFIED BY 'root@123!';

GRANT ALL PRIVILEGES ON alphabrief_db.*
TO 'alphabrief'@'%';

FLUSH PRIVILEGES;

-- =====================================================
-- USERS
-- =====================================================

CREATE TABLE users (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    phone_number VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,

    is_phone_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,

    last_login_at TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_phone_number
ON users(phone_number);

CREATE INDEX idx_users_email
ON users(email);

-- =====================================================
-- OTP VERIFICATIONS
-- =====================================================

CREATE TABLE otp_verifications (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    phone_number VARCHAR(20) NOT NULL,
    otp_code VARCHAR(10) NOT NULL,

    is_verified BOOLEAN DEFAULT FALSE,
    expires_at TIMESTAMP NOT NULL,
    verified_at TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_otp_phone_number
ON otp_verifications(phone_number);

-- =====================================================
-- USER PROFILES
-- =====================================================

CREATE TABLE user_profiles (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    user_id CHAR(36) NOT NULL UNIQUE,

    full_name VARCHAR(255) NOT NULL,
    whatsapp_number VARCHAR(20),

    timezone VARCHAR(100) DEFAULT 'Asia/Kolkata',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_profiles_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =====================================================
-- BROKER CONNECTIONS
-- =====================================================

CREATE TABLE broker_connections (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    user_id CHAR(36) NOT NULL,

    broker_name VARCHAR(50) NOT NULL,

    broker_user_id VARCHAR(255),

    access_token TEXT,
    refresh_token TEXT,

    token_expires_at TIMESTAMP,

    is_active BOOLEAN DEFAULT TRUE,

    connected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    disconnected_at TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_broker_connections_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_broker_connections_user_id
ON broker_connections(user_id);

CREATE INDEX idx_broker_connections_broker_name
ON broker_connections(broker_name);

-- =====================================================
-- REPORT PREFERENCES
-- =====================================================

CREATE TABLE report_preferences (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    user_id CHAR(36) NOT NULL UNIQUE,

    report_frequency VARCHAR(20) NOT NULL DEFAULT 'weekly',

    delivery_method VARCHAR(20) NOT NULL DEFAULT 'email',

    preferred_day VARCHAR(20) DEFAULT 'Sunday',
    preferred_time TIME DEFAULT '19:00:00',

    is_enabled BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_report_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_report_frequency
        CHECK (report_frequency IN ('daily', 'weekly')),

    CONSTRAINT chk_delivery_method
        CHECK (delivery_method IN ('email', 'whatsapp'))
);

-- =====================================================
-- PORTFOLIO SNAPSHOTS
-- =====================================================

CREATE TABLE portfolio_snapshots (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    user_id CHAR(36) NOT NULL,
    broker_connection_id CHAR(36) NOT NULL,

    total_portfolio_value NUMERIC(15,2) NOT NULL,
    total_pnl NUMERIC(15,2),
    total_invested_amount NUMERIC(15,2),

    snapshot_date DATE NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_portfolio_snapshots_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_portfolio_snapshots_broker
        FOREIGN KEY (broker_connection_id)
        REFERENCES broker_connections(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_portfolio_snapshots_user_id
ON portfolio_snapshots(user_id);

CREATE INDEX idx_portfolio_snapshots_snapshot_date
ON portfolio_snapshots(snapshot_date);

-- =====================================================
-- SNAPSHOT HOLDINGS
-- =====================================================

CREATE TABLE snapshot_holdings (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    portfolio_snapshot_id CHAR(36) NOT NULL,

    symbol VARCHAR(50) NOT NULL,
    exchange VARCHAR(20),

    quantity NUMERIC(15,2) NOT NULL,

    average_price NUMERIC(15,2),
    current_price NUMERIC(15,2),

    invested_amount NUMERIC(15,2),
    current_value NUMERIC(15,2),

    pnl_amount NUMERIC(15,2),
    pnl_percentage NUMERIC(10,2),

    sector VARCHAR(100),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_snapshot_holdings_snapshot
        FOREIGN KEY (portfolio_snapshot_id)
        REFERENCES portfolio_snapshots(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_snapshot_holdings_snapshot_id
ON snapshot_holdings(portfolio_snapshot_id);

CREATE INDEX idx_snapshot_holdings_symbol
ON snapshot_holdings(symbol);

-- =====================================================
-- GENERATED REPORTS
-- =====================================================

CREATE TABLE generated_reports (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    user_id CHAR(36) NOT NULL,

    report_type VARCHAR(20) DEFAULT 'weekly',

    report_period_start DATE NOT NULL,
    report_period_end DATE NOT NULL,

    report_status VARCHAR(20) DEFAULT 'generated',

    pdf_url TEXT,
    report_summary TEXT,

    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_generated_reports_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_generated_report_status
        CHECK (report_status IN ('generated', 'failed', 'processing'))
);

CREATE INDEX idx_generated_reports_user_id
ON generated_reports(user_id);

CREATE INDEX idx_generated_reports_generated_at
ON generated_reports(generated_at);

-- =====================================================
-- REPORT DELIVERIES
-- =====================================================

CREATE TABLE report_deliveries (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    report_id CHAR(36) NOT NULL,

    delivery_method VARCHAR(20) NOT NULL,

    delivery_status VARCHAR(20) DEFAULT 'pending',

    delivered_to VARCHAR(255),

    provider_message_id VARCHAR(255),

    failure_reason TEXT,

    delivered_at TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_report_deliveries_report
        FOREIGN KEY (report_id)
        REFERENCES generated_reports(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_delivery_method
        CHECK (delivery_method IN ('email', 'whatsapp')),

    CONSTRAINT chk_delivery_status
        CHECK (delivery_status IN ('pending', 'sent', 'failed'))
);

CREATE INDEX idx_report_deliveries_report_id
ON report_deliveries(report_id);

-- =====================================================
-- AUDIT LOGS
-- =====================================================

CREATE TABLE audit_logs (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    user_id CHAR(36),

    action VARCHAR(255) NOT NULL,

    entity_type VARCHAR(100),
    entity_id CHAR(36),

    metadata JSON,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_logs_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE SET NULL
);

CREATE INDEX idx_audit_logs_user_id
ON audit_logs(user_id);

CREATE INDEX idx_audit_logs_action
ON audit_logs(action);
