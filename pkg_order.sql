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
CREATE OR REPLACE PACKAGE BODY pkg_order AS

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
    ) as
    begin
        null;
    end advance_order_status;

END pkg_order;
/