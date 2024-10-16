----------
---PS_3---
----------

---TABLES---
--------------------------------------------------
--------------------ADDRESS-----------------------
--------------------------------------------------
CREATE TABLE address (
    address_id      VARCHAR2(32 BYTE) NOT NULL,
    address_line1   VARCHAR2(50 BYTE) NOT NULL,
    address_line2   VARCHAR2(50 BYTE),
    address_line3   VARCHAR2(50 BYTE),
    address_city    VARCHAR2(40 BYTE) NOT NULL,
    address_state   CHAR(2 BYTE) NOT NULL,
    address_zip     VARCHAR2(9 BYTE) NOT NULL,
    address_crtd_id VARCHAR2(40 BYTE) NOT NULL,
    address_crtd_dt DATE NOT NULL,
    address_updt_id VARCHAR2(40 BYTE) NOT NULL,
    address_updt_dt DATE NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY ( address_id ) ENABLE
);
    
--------------------------------------------------
------------------ADDRESS_TYPE--------------------
--------------------------------------------------
CREATE TABLE address_type (
    address_type_id      VARCHAR2(32) NOT NULL,
    address_type_desc    VARCHAR2(10) NOT NULL,
    address_type_crtd_id VARCHAR2(40) NOT NULL,
    address_type_crtd_dt DATE NOT NULL,
    address_type_updt_id VARCHAR2(40) NOT NULL,
    address_type_updt_dt DATE NOT NULL,
    CONSTRAINT address_type_pk PRIMARY KEY ( address_type_id ) ENABLE
);

--------------------------------------------------
----------------CUSTOMER_ADDRESS------------------
--------------------------------------------------
CREATE TABLE customer_address (
    customer_address_id              VARCHAR2(32 BYTE) NOT NULL,
    customer_address_customer_id     VARCHAR2(32 BYTE) NOT NULL,
    customer_address_address_id      VARCHAR2(32 BYTE) NOT NULL,
    customer_address_address_type_id VARCHAR2(32 BYTE) NOT NULL,
    customer_address_actv_ind        NUMBER(1, 0) NOT NULL,
    customer_address_default_ind     NUMBER(1, 0) NOT NULL,
    customer_address_crtd_id         VARCHAR2(40 BYTE) NOT NULL,
    customer_address_crtd_dt         DATE NOT NULL,
    customer_address_updt_id         VARCHAR2(40 BYTE) NOT NULL,
    customer_address_updt_dt         DATE NOT NULL,
    CONSTRAINT customer_address_pk PRIMARY KEY ( customer_address_id ) ENABLE
);

ALTER TABLE customer_address
    ADD CONSTRAINT customer_address_fk1 FOREIGN KEY ( customer_address_customer_id )
        REFERENCES customer ( customer_id )
    ENABLE;

ALTER TABLE customer_address
    ADD CONSTRAINT customer_address_fk2 FOREIGN KEY ( customer_address_address_id )
        REFERENCES address ( address_id )
    ENABLE;

ALTER TABLE customer_address
    ADD CONSTRAINT customer_address_fk3 FOREIGN KEY ( customer_address_address_type_id )
        REFERENCES address_type ( address_type_id )
    ENABLE;
    
--------------------------------------------------
-------------------ORDER_STATUS-------------------
--------------------------------------------------
CREATE TABLE order_status (
    order_status_id                   VARCHAR2(32 BYTE) NOT NULL,
    order_status_desc                 VARCHAR2(20 BYTE) NOT NULL,
    order_status_next_order_status_id VARCHAR2(32 BYTE),
    order_status_crtd_id              VARCHAR2(40 BYTE) NOT NULL,
    order_status_crtd_dt              DATE NOT NULL,
    order_status_updt_id              VARCHAR2(40 BYTE) NOT NULL,
    order_status_updt_dt              DATE NOT NULL,
    CONSTRAINT order_status_pk PRIMARY KEY ( order_status_id ) ENABLE
);

ALTER TABLE order_status
    ADD CONSTRAINT order_status_fk1 FOREIGN KEY ( order_status_next_order_status_id )
        REFERENCES order_status ( order_status_id )
    DEFERRABLE INITIALLY DEFERRED ENABLE;

--------------------------------------------------
-------------------ORDER_STATE--------------------
--------------------------------------------------
CREATE TABLE order_state (
    order_state_id              VARCHAR2(32) NOT NULL,
    order_state_orders_id       VARCHAR2(32) NOT NULL,
    order_state_order_status_id VARCHAR2(32) NOT NULL,
    order_state_eff_date        DATE NOT NULL,
    order_state_crtd_id         VARCHAR2(40) NOT NULL,
    order_state_crtd_dt         DATE NOT NULL,
    order_state_updt_id         VARCHAR2(40) NOT NULL,
    order_state_updt_dt         DATE NOT NULL,
    CONSTRAINT order_state_pk PRIMARY KEY ( order_state_id ) ENABLE
);

ALTER TABLE order_state
    ADD CONSTRAINT order_state_fk1 FOREIGN KEY ( order_state_orders_id )
        REFERENCES orders ( orders_id )
    ENABLE;

ALTER TABLE order_state
    ADD CONSTRAINT order_state_fk2 FOREIGN KEY ( order_state_order_status_id )
        REFERENCES order_status ( order_status_id )
    ENABLE;
    
--------------------------------------------------
--------------------------------------------------
BEGIN
    prc_create_triggers();
END;
/

--ADDRESS, ADDRESS_TYPE, CUSTOMER_ADDRESS, ORDER_STATUS, ORDER_STATE

--------------------------------------------------
-----------------ADDRESS__TRG01-------------------
--------------------------------------------------
create or replace TRIGGER trg01_address BEFORE
    INSERT OR UPDATE ON address
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.address_crtd_id := user;
        :new.address_crtd_dt := sysdate;
    END IF;

    :new.address_updt_id := user;
    :new.address_updt_dt := sysdate;
END;
/
--------------------------------------------------
-----------------ADDRESS__TRG02-------------------
--------------------------------------------------
create or replace TRIGGER trg02_address BEFORE
    INSERT OR UPDATE ON address
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.address_id := sys_guid();
    ELSE
        :new.address_id := :old.address_id;
    END IF;
END;
/
--------------------------------------------------
---------------ADDRESS_TYPE__TRG01----------------
--------------------------------------------------
create or replace TRIGGER trg01_address_type BEFORE
    INSERT OR UPDATE ON address_type
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.address_type_crtd_id := user;
        :new.address_type_crtd_dt := sysdate;
    END IF;

    :new.address_type_updt_id := user;
    :new.address_type_updt_dt := sysdate;
END;
/
--------------------------------------------------
---------------ADDRESS_TYPE__TRG02----------------
--------------------------------------------------
create or replace TRIGGER trg02_address_type BEFORE
    INSERT OR UPDATE ON address_type
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.address_type_id := sys_guid();
    ELSE
        :new.address_type_id := :old.address_type_id;
    END IF;
END;
/
--------------------------------------------------
-------------CUSTOMER_ADDRESS__TRG01--------------
--------------------------------------------------
create or replace TRIGGER trg01_customer_address BEFORE
    INSERT OR UPDATE ON customer_address
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.customer_address_crtd_id := user;
        :new.customer_address_crtd_dt := sysdate;
    END IF;

    :new.customer_address_updt_id := user;
    :new.customer_address_updt_dt := sysdate;
END;
/
--------------------------------------------------
-------------CUSTOMER_ADDRESS__TRG02--------------
--------------------------------------------------
create or replace TRIGGER trg02_customer_address BEFORE
    INSERT OR UPDATE ON customer_address
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.customer_address_id := sys_guid();
    ELSE
        :new.customer_address_id := :old.customer_address_id;
    END IF;
END;
/
--------------------------------------------------
--------------ORDER_STATUS__TRG01-----------------
--------------------------------------------------
create or replace TRIGGER trg01_order_status BEFORE
    INSERT OR UPDATE ON order_status
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.order_status_crtd_id := user;
        :new.order_status_crtd_dt := sysdate;
    END IF;

    :new.order_status_updt_id := user;
    :new.order_status_updt_dt := sysdate;
END;
/
--------------------------------------------------
--------------ORDER_STATUS__TRG02-----------------
--------------------------------------------------
create or replace TRIGGER trg02_order_status BEFORE
    INSERT OR UPDATE ON order_status
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.order_status_id := sys_guid();
    ELSE
        :new.order_status_id := :old.order_status_id;
    END IF;
END;
/
--------------------------------------------------
--------------ORDER_STATE__TRG01------------------
--------------------------------------------------
create or replace TRIGGER trg01_order_state BEFORE
    INSERT OR UPDATE ON order_state
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.order_state_crtd_id := user;
        :new.order_state_crtd_dt := sysdate;
    END IF;

    :new.order_state_updt_id := user;
    :new.order_state_updt_dt := sysdate;
END;
/
--------------------------------------------------
--------------ORDER_STATE__TRG02------------------
--------------------------------------------------
create or replace TRIGGER trg02_order_state BEFORE
    INSERT OR UPDATE ON order_state
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.order_state_id := sys_guid();
    ELSE
        :new.order_state_id := :old.order_state_id;
    END IF;
END;
/

--------------------------------------------------
-------------RECORDS FOR ORDER_STATUS-------------
--------------------------------------------------
BEGIN
    INSERT INTO ORDER_STATUS (ORDER_STATUS_DESC) VALUES ('New');
    INSERT INTO ORDER_STATUS (ORDER_STATUS_DESC) VALUES ('Picking');
    INSERT INTO ORDER_STATUS (ORDER_STATUS_DESC) VALUES ('Picked');
    INSERT INTO ORDER_STATUS (ORDER_STATUS_DESC) VALUES ('Shipping');
    INSERT INTO ORDER_STATUS (ORDER_STATUS_DESC) VALUES ('Shipped');
    
    update order_status
    SET ORDER_STATUS_NEXT_ORDER_STATUS_ID = (SELECT ORDER_STATUS_ID FROM ORDER_STATUS WHERE ORDER_STATUS_DESC = 'Picking')
    WHERE ORDER_STATUS_DESC = 'New';

    update order_status
    SET ORDER_STATUS_NEXT_ORDER_STATUS_ID = (SELECT ORDER_STATUS_ID FROM ORDER_STATUS WHERE ORDER_STATUS_DESC = 'Picked')
    WHERE ORDER_STATUS_DESC = 'Picking';
    
    update order_status
    SET ORDER_STATUS_NEXT_ORDER_STATUS_ID = (SELECT ORDER_STATUS_ID FROM ORDER_STATUS WHERE ORDER_STATUS_DESC = 'Shipping')
    WHERE ORDER_STATUS_DESC = 'Picked';
    
    update order_status
    SET ORDER_STATUS_NEXT_ORDER_STATUS_ID = (SELECT ORDER_STATUS_ID FROM ORDER_STATUS WHERE ORDER_STATUS_DESC = 'Shipped')
    WHERE ORDER_STATUS_DESC = 'Shipping';
END;
/
commit;

--DECLARE
--    V_NEW_STATUS VARCHAR2(32);
--    V_PICKING_STATUS VARCHAR2(32);
--    V_PICKED_STATUS VARCHAR2(32);
--    V_SHIPPING_STATUS VARCHAR2(32);
--    V_SHIPPED_STATUS VARCHAR2(32);
--BEGIN
--    V_NEW_STATUS := sys.guid();
--    V_PICKING_STATUS := sys.guid();
--    V_PICKED_STATUS := sys.guid();
--    V_SHIPPING_STATUS := sys.guid();
--    V_SHIPPED_STATUS := sys.guid();
--
--    INSERT INTO order_status (
--        order_status_id,
--        order_status_desc,
--        order_status_next_order_status_id
--    ) VALUES (
--        v_picking_status,
--        'Picking',
--        v_picked_status
--    );
--    
--        INSERT INTO order_status (
--        order_status_id,
--        order_status_desc,
--        order_status_next_order_status_id
--    ) VALUES (
--        v_picked_status,
--        'Picked',
--        v_shipping_status
--    );
--    
--        INSERT INTO order_status (
--        order_status_id,
--        order_status_desc,
--        order_status_next_order_status_id
--    ) VALUES (
--        v_shipping_status,
--        'Shipping',
--        v_shipped_status
--    );
--    
--        INSERT INTO order_status (
--        order_status_id,
--        order_status_desc,
--        order_status_next_order_status_id
--    ) VALUES (
--        v_shipped_status,
--        'Shipped',
--        null
--    );
--END;
--/
--commit;

--------------------------------------------------
--------------------Package-----------------------
--------------------------------------------------
--Whenever oserror exit 9;
--Whenever sqlerror exit sql.sqlcode;
--set appinfo on
--
--SELECT
--    'Begin Executing ' || sys_context('USERENV', 'MODULE') "MSG"
--FROM
--    "SYS"."DUAL" "A1";

CREATE OR REPLACE PACKAGE pkg_order AS
    PROCEDURE set_order_status (
        order_state_orders_id_in       orders.orders_id%TYPE,
        order_state_order_status_id_in order_state.order_state_order_status_id%TYPE,
        order_state_eff_date_in        order_state.order_state_eff_date%TYPE
    );

    PROCEDURE advance_order_status (
        orders_id_in            orders.orders_id%TYPE,
        order_state_eff_date_in order_state.order_state_eff_date%TYPE
    );

END pkg_order;
/

--------------------------------------------------
------------------PACKAGE_UDATING-----------------
--------------------------------------------------

CREATE OR REPLACE PACKAGE BODY pkg_order AS

    FUNCTION order_status_curr (
        order_id_in VARCHAR2
    ) RETURN VARCHAR2 AS
        
        v_count NUMBER(3);
        CURSOR c_status IS
        SELECT
            *
        FROM
            (
                SELECT
                    order_status_id,
                    order_status_desc,
                    level lvl
                FROM
                    order_status
                CONNECT BY
                    PRIOR order_status_id = order_status_next_order_status_id
                START WITH order_status_next_order_status_id IS NULL
            )
        ORDER BY
            lvl;
            
    BEGIN
        FOR r_status IN c_status LOOP
            SELECT
                COUNT(*)
            INTO v_count
            FROM
                order_state
            WHERE
                    order_state_orders_id = order_id_in
                AND order_state_order_status_id = r_status.order_status_id;
            
            IF v_count > 0 THEN
                RETURN r_status.order_status_id;
            END IF;
        END LOOP;
        
        RETURN NULL;
    END order_status_curr;

    FUNCTION next_status_func (
        order_status_id_in VARCHAR2
    ) RETURN VARCHAR2 AS
        v_next_order_status_id VARCHAR2(32);
        v_count                NUMBER(1);
    BEGIN
        IF order_status_id_in IS NULL THEN
            SELECT
                order_status_id
            INTO v_next_order_status_id
            FROM
                order_status
            WHERE
                order_status_id NOT IN (
                    SELECT
                        order_status_next_order_status_id
                    FROM
                        order_status
                    WHERE
                        order_status_next_order_status_id IS NOT NULL
                );

            RETURN v_next_order_status_id;
        END IF;

        SELECT
            COUNT(*)
        INTO v_count
        FROM
            order_status
        WHERE
            order_status_id = order_status_id_in;

        IF v_count = 0 THEN
            RETURN NULL;
        END IF;
        SELECT
            order_status_next_order_status_id
        INTO v_next_order_status_id
        FROM
            order_status
        WHERE
            order_status_id = order_status_id_in;

        RETURN v_next_order_status_id;
    END next_status_func;

    PROCEDURE set_order_status (
        order_state_orders_id_in       orders.orders_id%TYPE,
        order_state_order_status_id_in order_state.order_state_order_status_id%TYPE,
        order_state_eff_date_in        order_state.order_state_eff_date%TYPE
    ) AS
    BEGIN
        INSERT INTO order_state (
            order_state_id,
            order_state_orders_id,
            order_state_order_status_id,
            order_state_eff_date
        ) VALUES (
            sys_guid(),
            order_state_orders_id_in,
            order_state_order_status_id_in,
            order_state_eff_date_in
        );

    END set_order_status;

    PROCEDURE advance_order_status (
        orders_id_in            orders.orders_id%TYPE,
        order_state_eff_date_in order_state.order_state_eff_date%TYPE
    ) AS
        v_current_order_status_id VARCHAR2(32);
        v_next_order_status_id    VARCHAR2(32);
    BEGIN
        v_current_order_status_id := order_status_curr(orders_id_in);
        v_next_order_status_id := next_status_func(v_current_order_status_id);
        IF v_next_order_status_id IS NOT NULL THEN
            set_order_status(orders_id_in, v_next_order_status_id, order_state_eff_date_in);
        END IF;
    END advance_order_status;

END pkg_order;
/