CREATE SEQUENCE seq_audit_key
MINVALUE 1 START WITH 1 INCREMENT BY 1;

--frequently updated (no index)
CREATE TABLE T_AUDITS (
    au_audit_id NUMBER(19) DEFAULT seq_audit_for_key.nextval NOT NULL,
    au_history VARCHAR(200) NOT NULL,
    au_status VARCHAR(100) NOT NULL,
    au_payment_value NUMBER(38) NOT NULL,
    PRIMARY KEY (au_audit_id)
);

CREATE SEQUENCE seq_client_key
MINVALUE 1 START WITH 1 INCREMENT BY 1;

CREATE TABLE T_CLIENTS (
    cl_client_id NUMBER(19) DEFAULT seq_client_for_key.NEXTVAL NOT NULL,
    cl_organisation_name VARCHAR(200) NOT NULL,
    cl_status_yn NUMBER(1) NOT NULL,
    cl_contact_fio VARCHAR(300) NOT NULL,
    cl_contact_phone_number VARCHAR(12) NOT NULL,
    cl_registation_date DATE NOT NULL,
    cl_contact_email VARCHAR(100) NOT NULL,
    cl_address VARCHAR(250),
    PRIMARY KEY (cl_client_id)
);

CREATE UNIQUE INDEX idx_clients_01_uk ON T_CLIENTS (cl_organisation_name);
CREATE INDEX idx_clients_01 ON T_CLIENTS (cl_registation_date);

CREATE SEQUENCE seq_account_key
MINVALUE 1 START WITH 1 INCREMENT BY 1;

CREATE TABLE T_ACCOUNTS (
    ac_account_id NUMBER (19) DEFAULT seq_account_for_key.NEXTVAL NOT NULL,
    ac_number NUMBER (38) NOT NULL,
    ac_client_id NUMBER (19) NOT NULL,
    PRIMARY KEY (ac_account_id),

    CONSTRAINT fk_accounts_clients_01
        FOREIGN KEY (ac_client_id) REFERENCES T_CLIENTS (client_id)
);

CREATE INDEX idx_accounts_01 ON T_ACCOUNTS (ac_number);
CREATE INDEX idx_accounts_02 ON T_ACCOUNTS (ac_client_id);

CREATE SEQUENCE seq_account_balances_key
MINVALUE 1 START WITH 1 INCREMENT BY 1;

--small table (no index)
CREATE TABLE T_ACCOUNT_BALANCES (
    ab_id NUMBER(19) DEFAULT seq_account_balances_key.NEXTVAL NOT NULL,
    ab_sum NUMBER(38) NOT NULL,
    ab_account_id NUMBER(19) NOT NULL,
    PRIMARY KEY (ab_id),

    CONSTRAINT fk_account_balances_01
        FOREIGN KEY (ab_account_id) REFERENCES T_ACCOUNTS (ac_account_id)
);

CREATE SEQUENCE seq_account_form_key
MINVALUE 1 START WITH 1 INCREMENT BY 1;

--account forms
CREATE TABLE T_ACCOUNT_FORMS (
    af_id NUMBER(19) DEFAULT seq_account_form_key.NEXTVAL NOT NULL,
    af_sender_id NUMBER(19) NOT NULL,
    af_recipient_id NUMBER(19) NOT NULL,
    af_client_id NUMBER(19) NOT NULL,
    af_number NUMBER(38) NOT NULL,
    af_responsible_emp VARCHAR(600) NOT NULL,
    af_date DATE NOT NULL,
    PRIMARY KEY (af_id),

    CONSTRAINT fk_account_forms_clients_01
        FOREIGN KEY (af_client_id) REFERENCES T_CLIENTS (cl_client_id),

    CONSTRAINT fk_account_forms__01
        FOREIGN KEY (af_sender_id) REFERENCES T_ACCOUNTS (ac_account_id),

    CONSTRAINT fk_account_forms_02
        FOREIGN KEY (af_recipient_id) REFERENCES T_ACCOUNTS (ac_account_id)
);

CREATE INDEX idx_account_forms_01 ON T_ACCOUNT_FORMS(af_client_id);

CREATE SEQUENCE seq_regular_payment_key
MINVALUE 1 START WITH 1 INCREMENT BY 1;

--regular payments
CREATE TABLE T_REGULAR_PAYMENTS (
    rp_id NUMBER(19) DEFAULT seq_regular_payment_key.NEXTVAL NOT NULL,
    rp_af_id NUMBER(19) NOT NULL,
    rp_sender_id NUMBER(19) NOT NULL,
    rp_recipient_id NUMBER(19) NOT NULL,
    rp_execution_date DATE NOT NULL,
    rp_status_yn NUMBER(1) NOT NULL,
    PRIMARY KEY (rp_id),

    CONSTRAINT fk_regular_payments_forms_01
        FOREIGN KEY (rp_af_id) REFERENCES T_ACCOUNT_FORMS (af_id),

    CONSTRAINT fk_regular_payments_accounts_01
        FOREIGN KEY (rp_sender_id) REFERENCES T_ACCOUNTS (ac_account_id),

    CONSTRAINT fk_regular_payments_accounts_02
        FOREIGN KEY (rp_recipient_id) REFERENCES T_ACCOUNTS (ac_account_id)
);

CREATE INDEX idx_regular_payments_01 ON T_REGULAR_PAYMENTS (rp_sender_id);
CREATE INDEX idx_regular_payments_02 ON T_REGULAR_PAYMENTS (rp_recipient_id);

--payments
CREATE SEQUENCE seq_payment_key
MINVALUE 1 START WITH 1 INCREMENT BY 1;

CREATE TABLE T_PAYMENTS (
    pa_payment_id NUMBER(19) DEFAULT seq_payment_key.NEXTVAL NOT NULL,
    pa_sender_id NUMBER(19) NOT NULL,
    pa_recipient_id NUMBER(19) NOT NULL,
    pa_amount NUMBER(38) NOT NULL,
    pa_status VARCHAR(250) NOT NULL,
    pa_currency_type VARCHAR(250) NOT NULL,
    pa_regular_payment_id NUMBER(19) NOT NULL,
    pa_account_form_id NUMBER(19) NOT NULL,
    pa_audit_id NUMBER(19) NOT NULL,
    PRIMARY KEY(pa_payment_id),

    CONSTRAINT fk_payments_accounts_01
        FOREIGN KEY (pa_sender_id) REFERENCES T_ACCOUNTS (ac_account_id),

    CONSTRAINT fk_payments_accounts_02
        FOREIGN KEY (pa_recipient_id) REFERENCES T_ACCOUNTS (ac_account_id),

    CONSTRAINT fk_payments_forms_01
        FOREIGN KEY (pa_account_form_id) REFERENCES T_ACCOUNT_FORMS(af_id),

    CONSTRAINT fk_payments_audits_01
        FOREIGN KEY (pa_audit_id) REFERENCES T_AUDITS(au_audit_id),

    CONSTRAINT fk_regs_payments_01
        FOREIGN KEY (pa_regular_payment_id) REFERENCES T_REGULAR_PAYMENTS(rp_id)
);

CREATE INDEX idx_payments_01 ON T_PAYMENTS (pa_sender_id);
CREATE INDEX idx_payments_02 ON T_PAYMENTS (pa_recipient_id);

--TRANSACTION
CREATE SEQUENCE seq_transaction_key
MINVALUE 1 START WITH 1 INCREMENT BY 1;

--frequently updated (no index)
CREATE TABLE T_TRANSACTIONS(
    tr_transaction_id NUMBER(19) DEFAULT seq_transaction_key.NEXTVAL NOT NULL,
    tr_payment_id NUMBER(19) NOT NULL,
    tr_sender_id NUMBER(19) NOT NULL,
    tr_recipient_id NUMBER(19) NOT NULL,
    tr_amount NUMBER(38) NOT NULL,
    PRIMARY KEY (tr_transaction_id),
    CONSTRAINT fk_transactions_payments_01
        FOREIGN KEY (tr_payment_id) REFERENCES T_PAYMENTS(pa_payment_id)
);