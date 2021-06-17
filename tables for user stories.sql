#Client can see list of available services
SELECT 
	service.specialization AS '', 
	request.date_of_event AS 'date of event', 
    service.name, 
    service.description, 
    service.type,
    IF(service.specialization = 'location', request.duration_location, IF(service.specialization = 'photographer',request.duration_photographer, IF(service.specialization = 'entertainment',service.duration, NULL))) AS 'duration, h', 
    service.size AS 'size, m2', 
    service.address,
    IF(service.specialization = 'catering',request.number_of_persons,NULL) AS 'number of persons', 
    calculated_services.price_per_event AS 'price per event, EUR' 
FROM request
		JOIN calculated_services ON request.request_ID = calculated_services.request_ID
		JOIN service ON calculated_services.service_ID = service.service_ID
WHERE request.request_ID = 15;


#Client can see list of requests
SELECT 
	request_ID AS 'request #',
    date_of_request AS 'date of request', 
    date_of_event AS 'date of event', 
    deadline, 
    request_status AS 'request status'
FROM request
WHERE client_ID = 882;


#Client can see list of orders
SELECT 
	order_.order_number AS 'order # ', 
    request.date_of_event AS 'date of event',
    order_.offer_ID AS 'offer #', 
    event_manager.name AS 'event manager', 
    event_manager.phone, 
    order_.event_status AS 'event status'  
FROM order_
		JOIN offer ON order_.offer_ID = offer.offer_ID
		JOIN request ON request.request_ID = offer.request_ID
		JOIN event_manager ON order_.event_manager_id = event_manager.event_manager_id
WHERE order_.client_ID = 882;



#Client can see list of offers
SELECT 
	offer.offer_ID AS 'offer #', 
    request.date_of_event AS 'date of event', 
    offer.total_price AS 'total price, EUR', 
    request.deadline AS 'services are prebooked until' 
FROM offer
		JOIN request ON request.request_ID = offer.request_ID
WHERE request.client_ID = 882;



#Client can see offer's details
SELECT 
	service.specialization AS '', 
	offer.offer_ID AS 'offer #', 
    service.name, 
    service.description, 
    service.type,
    IF(service.specialization = 'location',request.duration_location,IF(service.specialization = 'photographer',request.duration_photographer, IF(service.specialization = 'entertainment',service.duration, NULL))) AS 'duration, h', 
    service.size AS 'size, m2', 
    service.address,
    IF(service.specialization = 'catering',request.number_of_persons,NULL) AS 'number of persons', 
    calculated_services.price_per_event AS 'price per event, EUR' 
FROM offer
		JOIN request ON request.request_ID = offer.request_ID 
		JOIN calculated_services ON request.request_ID = calculated_services.request_ID
		JOIN service ON calculated_services.service_ID = service.service_ID
WHERE request.client_ID = 882;
    
    
    
#Service provider can see list of received booking requests
SELECT 
	service.specialization AS '', 
    request.request_ID AS 'request #', 
    request.date_of_event AS 'date of event', 
    request.deadline AS 'deadline', 
    client.company_name AS 'client name', 
    service.service_ID AS 'service #', 
    IF(service.specialization = 'location',request.duration_location,IF(service.specialization = 'photographer',request.duration_photographer, IF(service.specialization = 'entertainment',service.duration, NULL))) AS 'duration, h', 
    calculated_services.price_per_event AS 'price per event, EUR', 
    calculated_services.booking_status AS 'booking status'
FROM service
		JOIN calculated_services ON service.service_ID = calculated_services.service_ID
		JOIN request ON request.request_ID = calculated_services.request_ID
		JOIN client ON client.client_ID = request.client_ID
WHERE calculated_services.booking_status = 'waiting' AND service.service_provider_ID = 39;
    
    
    
#Service provider can see list of services with details, which can be provided via the system 
SELECT 
	service.specialization AS '', 
    service.service_ID AS 'service #', 
    service.name,
    service.type,
    IF(service.specialization = 'entertainment', service.duration, NULL) AS 'duration, h', 
    service.size AS 'size, m2', 
    service.address,
    service.price_per_hour AS 'price per hour, EUR',
    service.price_per_day AS 'price per day, EUR',
    service.price_per_performance AS 'price per performance, EUR',
	service.price_per_person AS 'price per person, EUR'
FROM service
		JOIN service_provider ON service.service_provider_ID = service_provider.service_provider_ID
WHERE service_provider.service_provider_ID = 62;

#Service provider can access details of the service, for which was received booking request
    SELECT 
	service.specialization AS '', 
    service.service_ID AS 'service #', 
    service.name,
    service.type,
    IF(service.specialization = 'entertainment', service.duration, NULL) AS 'duration, h', 
    service.size AS 'size, m2', 
    service.address,
    service.price_per_hour AS 'price per hour, EUR',
    service.price_per_day AS 'price per day, EUR',
    service.price_per_performance AS 'price per performance, EUR',
	service.price_per_person AS 'price per person, EUR'
FROM service
		JOIN service_provider ON service.service_provider_ID = service_provider.service_provider_ID
WHERE service.service_ID = 50;

#Event manager can see list of assigned orders
SELECT 
	order_.order_number AS 'order #',
    request.date_of_event AS 'date of event',
    client.company_name AS 'client company', 
    client.contact_person AS 'contact person', 
    client.phone,
    order_.event_status AS 'event status'
FROM order_
		JOIN offer ON offer.offer_ID = order_.offer_ID
		JOIN request ON request.request_ID = offer.request_ID
		JOIN client ON client.client_ID = request.client_ID
		JOIN event_manager ON event_manager.event_manager_ID = order_.event_manager_ID
WHERE order_.event_manager_ID = 1;
    
    
    
#Event manager can see event details
SELECT 
	service.specialization AS '', 
	order_.order_number AS 'order #',
    service.name AS 'service name', 
    IF(service.contact_person IS NULL, service_provider.contact_person,  service.contact_person) AS 'contact person',
    service.phone,
    service.description, 
    service.type,
    IF(service.specialization = 'location',request.duration_location,IF(service.specialization = 'photographer',request.duration_photographer, IF(service.specialization = 'entertainment',service.duration, NULL))) AS 'duration, h', 
    service.size AS 'size, m2', 
    service.address,
    IF(service.specialization = 'catering',request.number_of_persons,NULL) AS 'number of persons'
FROM service
		JOIN booked_services ON booked_services.service_ID = service.service_ID
		JOIN offer ON booked_services.offer_ID = offer.offer_ID
		JOIN order_ ON order_.offer_ID = offer.offer_ID
		JOIN request ON request.request_ID = offer.request_ID
		JOIN event_manager ON event_manager.event_manager_ID = order_.event_manager_ID
		JOIN service_provider ON service_provider.service_provider_id = service.service_provider_ID
WHERE event_manager.event_manager_ID = 77;
    
    
#Service provider has access to contact information of the event manager
SELECT 
	service.specialization AS '', 
	order_.order_number AS 'order #',
    request.date_of_event AS 'date of event',
    client.company_name AS 'client company', 
    service.service_ID AS 'service #', 
    IF(service.specialization = 'location',request.duration_location,IF(service.specialization = 'photographer',request.duration_photographer, IF(service.specialization = 'entertainment',service.duration, NULL))) AS 'duration, h', 
    IF(service.specialization = 'catering',request.number_of_persons,NULL) AS 'number of persons',
    calculated_services.price_per_event AS 'price per event, EUR', 
    event_manager.name AS 'event manager',
    event_manager.phone,
    order_.event_status aS 'event status'
FROM service
		JOIN calculated_services ON service.service_ID = calculated_services.service_ID
		JOIN request ON request.request_ID = calculated_services.request_ID
		JOIN client ON client.client_ID = request.client_ID
        JOIN order_ ON client.client_ID = order_.client_ID
        JOIN event_manager ON event_manager.event_manager_ID = order_.event_manager_ID
WHERE service.service_provider_ID = 19;
    
   
    

#Event manager can contact the client via system
SELECT 
	order_.order_number AS 'order #',
    request.date_of_event AS 'date of event',
    client.company_name AS 'client company', 
    client.contact_person AS 'contact person',
    client.phone,
    order_.event_status AS 'event status'
FROM order_
		JOIN client ON client.client_ID = order_.client_ID
		JOIN request ON client.client_ID = request.client_ID
		JOIN event_manager ON event_manager.event_manager_ID = order_.event_manager_ID
WHERE event_manager.event_manager_ID = 1;
    
#invoice data 
SELECT
	CONCAT_WS("\r\n", client.contact_person, client.address, client.phone, client.email) AS 'BILL TO',
    invoice.invoice_number AS 'INVOICE #',
    invoice.date AS 'DATE',
    invoice.due_date AS 'DUE DATE',
    invoice.offer_ID AS 'OFFER',
    'PRE PAYMENT' AS 'TERMS',
    CONCAT_WS(' ',service.specialization,service.name )  AS 'DESCRIPTION', 
    IF(service.specialization = 'catering',request.number_of_persons,IF(service.specialization = 'location', request.duration_location, IF(service.specialization = 'photographer',request.duration_photographer, IF(service.specialization = 'entertainment',service.duration, NULL)))) AS 'QTY (location, photographer, entertainment - hours, catering - persons)', 
    calculated_services.price_per_event * 0.8 AS 'AMOUNT WITHOUT TAX',
    calculated_services.price_per_event AS 'AMOUNT WITH TAX',
    offer.total_price *0.8 AS 'SUBTOTAL',
    '20,000%' AS 'TAX RATE',
    offer.total_price *0.2 AS 'TAX',
    offer.total_price AS 'TOTAL'
FROM client
		JOIN request ON client.client_ID = request.client_ID
		JOIN offer ON request.request_ID= offer.request_ID
		JOIN invoice ON invoice.offer_ID = offer.offer_ID
        JOIN calculated_services ON calculated_services.request_ID = request.request_ID
		JOIN service ON  calculated_services.service_ID = service.service_ID	
WHERE invoice.order_number = '1';
    
    
USE ie_test;
    
    