--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE customers (
    id integer NOT NULL,
    end_subscription date,
    take_over time without time zone,
    job_destination_geocoding_id integer,
    job_optimizer_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255),
    tomtom_account character varying(255),
    tomtom_user character varying(255),
    tomtom_password character varying(255),
    router_id integer NOT NULL,
    print_planning_annotating boolean,
    print_header text,
    masternaut_user character varying(255),
    masternaut_password character varying(255),
    enable_orders boolean DEFAULT false NOT NULL,
    test boolean DEFAULT false NOT NULL,
    alyacom_association character varying(255),
    optimization_cluster_size integer,
    optimization_time integer,
    optimization_soft_upper_bound integer,
    profile_id integer NOT NULL,
    speed_multiplicator double precision DEFAULT 1.0 NOT NULL,
    default_country character varying NOT NULL,
    enable_tomtom boolean DEFAULT false NOT NULL,
    enable_masternaut boolean DEFAULT false NOT NULL,
    enable_alyacom boolean DEFAULT false NOT NULL,
    job_store_geocoding_id integer,
    reseller_id integer NOT NULL,
    enable_multi_vehicle_usage_sets boolean DEFAULT false NOT NULL,
    print_stop_time boolean DEFAULT true NOT NULL,
    ref character varying,
    enable_references boolean DEFAULT true,
    enable_teksat boolean,
    teksat_customer_id integer,
    teksat_username character varying,
    teksat_password character varying,
    teksat_url character varying,
    enable_multi_visits boolean DEFAULT false NOT NULL,
    enable_orange boolean,
    orange_user character varying,
    orange_password character varying,
    router_dimension integer DEFAULT 0 NOT NULL,
    alyacom_api_key character varying,
    advanced_options text,
    print_map boolean DEFAULT false NOT NULL
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    progress character varying(255) DEFAULT '0'::character varying NOT NULL
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: destinations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE destinations (
    id integer NOT NULL,
    name character varying(255),
    street character varying(255),
    postalcode character varying(255),
    city character varying(255),
    lat double precision,
    lng double precision,
    customer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    detail character varying(255),
    comment text,
    geocoding_accuracy double precision,
    country character varying,
    geocoding_level integer,
    phone_number character varying,
    ref character varying
);


--
-- Name: destinations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE destinations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: destinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE destinations_id_seq OWNED BY destinations.id;


--
-- Name: destinations_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE destinations_tags (
    destination_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: layers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE layers (
    id integer NOT NULL,
    name character varying NOT NULL,
    url character varying NOT NULL,
    attribution character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    urlssl character varying NOT NULL,
    source character varying NOT NULL,
    "overlay" boolean DEFAULT false,
    print boolean DEFAULT false NOT NULL
);


--
-- Name: layers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE layers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: layers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE layers_id_seq OWNED BY layers.id;


--
-- Name: layers_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE layers_profiles (
    profile_id integer,
    layer_id integer
);


--
-- Name: order_arrays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE order_arrays (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    base_date date NOT NULL,
    length integer NOT NULL,
    customer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: order_arrays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE order_arrays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_arrays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE order_arrays_id_seq OWNED BY order_arrays.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE orders (
    id integer NOT NULL,
    shift integer NOT NULL,
    order_array_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    visit_id integer NOT NULL
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: orders_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE orders_products (
    order_id integer NOT NULL,
    product_id integer NOT NULL
);


--
-- Name: plannings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE plannings (
    id integer NOT NULL,
    name character varying(255),
    customer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    zoning_out_of_date boolean,
    order_array_id integer,
    ref character varying,
    date date,
    vehicle_usage_set_id integer NOT NULL
);


--
-- Name: plannings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE plannings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plannings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE plannings_id_seq OWNED BY plannings.id;


--
-- Name: plannings_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE plannings_tags (
    planning_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: plannings_zonings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE plannings_zonings (
    planning_id integer,
    zoning_id integer
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE products (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(255) NOT NULL,
    customer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE profiles (
    id integer NOT NULL,
    name character varying
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: profiles_routers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE profiles_routers (
    profile_id integer,
    router_id integer
);


--
-- Name: resellers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE resellers (
    id integer NOT NULL,
    host character varying NOT NULL,
    name character varying NOT NULL,
    welcome_url character varying,
    help_url character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    logo_large character varying,
    logo_small character varying,
    favicon character varying,
    contact_url character varying,
    website_url character varying
);


--
-- Name: resellers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resellers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resellers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resellers_id_seq OWNED BY resellers.id;


--
-- Name: routers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE routers (
    id integer NOT NULL,
    name character varying(255),
    url_time character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying(255) DEFAULT 'RouterOsrm'::character varying NOT NULL,
    url_isochrone character varying,
    url_isodistance character varying,
    url_distance character varying,
    mode character varying NOT NULL,
    "time" boolean DEFAULT true NOT NULL,
    distance boolean DEFAULT false NOT NULL,
    avoid_zones boolean DEFAULT false NOT NULL,
    isochrone boolean DEFAULT false NOT NULL,
    isodistance boolean DEFAULT false NOT NULL
);


--
-- Name: routers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE routers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: routers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE routers_id_seq OWNED BY routers.id;


--
-- Name: routes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE routes (
    id integer NOT NULL,
    distance double precision,
    emission double precision,
    planning_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    start timestamp without time zone,
    "end" timestamp without time zone,
    hidden boolean,
    locked boolean,
    out_of_date boolean,
    stop_trace text,
    stop_out_of_drive_time boolean,
    stop_distance double precision,
    ref character varying(255),
    color character varying,
    vehicle_usage_id integer,
    stop_drive_time integer,
    last_sent_at timestamp without time zone,
    optimized_at timestamp without time zone
);


--
-- Name: routes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE routes_id_seq OWNED BY routes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: stops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stops (
    id integer NOT NULL,
    index integer,
    active boolean,
    distance double precision,
    trace text,
    route_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "time" timestamp without time zone,
    out_of_window boolean,
    out_of_capacity boolean,
    out_of_drive_time boolean,
    wait_time integer,
    lock_version integer DEFAULT 0 NOT NULL,
    type character varying DEFAULT 'StopDestination'::character varying NOT NULL,
    drive_time integer,
    visit_id integer,
    CONSTRAINT check_visit_id CHECK ((((type)::text <> 'StopVisit'::text) OR (visit_id IS NOT NULL)))
);


--
-- Name: stops_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stops_id_seq OWNED BY stops.id;


--
-- Name: stores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stores (
    id integer NOT NULL,
    name character varying(255),
    street character varying(255),
    postalcode character varying(255),
    city character varying(255),
    lat double precision,
    lng double precision,
    customer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    country character varying,
    ref character varying,
    geocoding_accuracy double precision,
    geocoding_level integer,
    color character varying,
    icon character varying,
    icon_size character varying
);


--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stores_id_seq OWNED BY stores.id;


--
-- Name: stores_vehicules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stores_vehicules (
    store_id integer NOT NULL,
    vehicle_id integer NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    label character varying(255),
    customer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    color character varying(255),
    icon character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: tags_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags_visits (
    visit_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    customer_id integer,
    layer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    api_key character varying(255) NOT NULL,
    reseller_id integer,
    url_click2call character varying,
    ref character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    time_zone character varying DEFAULT 'UTC'::character varying NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: vehicle_usage_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vehicle_usage_sets (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    name character varying NOT NULL,
    open time without time zone NOT NULL,
    close time without time zone NOT NULL,
    store_start_id integer,
    store_stop_id integer,
    store_rest_id integer,
    rest_start time without time zone,
    rest_stop time without time zone,
    rest_duration time without time zone,
    service_time_start time without time zone,
    service_time_end time without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: vehicle_usage_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vehicle_usage_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicle_usage_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vehicle_usage_sets_id_seq OWNED BY vehicle_usage_sets.id;


--
-- Name: vehicle_usages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vehicle_usages (
    id integer NOT NULL,
    vehicle_usage_set_id integer NOT NULL,
    vehicle_id integer NOT NULL,
    open time without time zone,
    close time without time zone,
    store_start_id integer,
    store_stop_id integer,
    store_rest_id integer,
    rest_start time without time zone,
    rest_stop time without time zone,
    rest_duration time without time zone,
    service_time_start time without time zone,
    service_time_end time without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean DEFAULT true
);


--
-- Name: vehicle_usages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vehicle_usages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicle_usages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vehicle_usages_id_seq OWNED BY vehicle_usages.id;


--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vehicles (
    id integer NOT NULL,
    name character varying(255),
    emission double precision,
    consumption double precision,
    capacity integer,
    color character varying NOT NULL,
    customer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tomtom_id character varying(255),
    router_id integer,
    masternaut_ref character varying(255),
    speed_multiplicator double precision,
    ref character varying,
    capacity_unit character varying,
    contact_email character varying,
    teksat_id character varying,
    orange_id character varying,
    fuel_type character varying,
    router_dimension integer
);


--
-- Name: vehicles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vehicles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vehicles_id_seq OWNED BY vehicles.id;


--
-- Name: visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE visits (
    id integer NOT NULL,
    quantity double precision,
    open1 time without time zone,
    close1 time without time zone,
    ref character varying,
    take_over time without time zone,
    destination_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    open2 time without time zone,
    close2 time without time zone
);


--
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visits_id_seq OWNED BY visits.id;


--
-- Name: zones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE zones (
    id integer NOT NULL,
    polygon text,
    zoning_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    vehicle_id integer,
    name character varying,
    speed_multiplicator double precision DEFAULT 1.0 NOT NULL
);


--
-- Name: zones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE zones_id_seq OWNED BY zones.id;


--
-- Name: zonings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE zonings (
    id integer NOT NULL,
    name character varying(255),
    customer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: zonings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE zonings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zonings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE zonings_id_seq OWNED BY zonings.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY destinations ALTER COLUMN id SET DEFAULT nextval('destinations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY layers ALTER COLUMN id SET DEFAULT nextval('layers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_arrays ALTER COLUMN id SET DEFAULT nextval('order_arrays_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY plannings ALTER COLUMN id SET DEFAULT nextval('plannings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resellers ALTER COLUMN id SET DEFAULT nextval('resellers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY routers ALTER COLUMN id SET DEFAULT nextval('routers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY routes ALTER COLUMN id SET DEFAULT nextval('routes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stops ALTER COLUMN id SET DEFAULT nextval('stops_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores ALTER COLUMN id SET DEFAULT nextval('stores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usage_sets ALTER COLUMN id SET DEFAULT nextval('vehicle_usage_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usages ALTER COLUMN id SET DEFAULT nextval('vehicle_usages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicles ALTER COLUMN id SET DEFAULT nextval('vehicles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visits ALTER COLUMN id SET DEFAULT nextval('visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY zones ALTER COLUMN id SET DEFAULT nextval('zones_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY zonings ALTER COLUMN id SET DEFAULT nextval('zonings_id_seq'::regclass);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY destinations
    ADD CONSTRAINT destinations_pkey PRIMARY KEY (id);


--
-- Name: layers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT layers_pkey PRIMARY KEY (id);


--
-- Name: order_arrays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_arrays
    ADD CONSTRAINT order_arrays_pkey PRIMARY KEY (id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: plannings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plannings
    ADD CONSTRAINT plannings_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: resellers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resellers
    ADD CONSTRAINT resellers_pkey PRIMARY KEY (id);


--
-- Name: routers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY routers
    ADD CONSTRAINT routers_pkey PRIMARY KEY (id);


--
-- Name: routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: stops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stops
    ADD CONSTRAINT stops_pkey PRIMARY KEY (id);


--
-- Name: stores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vehicle_usage_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usage_sets
    ADD CONSTRAINT vehicle_usage_sets_pkey PRIMARY KEY (id);


--
-- Name: vehicle_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usages
    ADD CONSTRAINT vehicle_usages_pkey PRIMARY KEY (id);


--
-- Name: vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- Name: zones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zones
    ADD CONSTRAINT zones_pkey PRIMARY KEY (id);


--
-- Name: zonings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zonings
    ADD CONSTRAINT zonings_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: fk__destinations_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__destinations_customer_id ON destinations USING btree (customer_id);


--
-- Name: fk__order_arrays_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__order_arrays_customer_id ON order_arrays USING btree (customer_id);


--
-- Name: fk__orders_order_array_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__orders_order_array_id ON orders USING btree (order_array_id);


--
-- Name: fk__orders_products_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__orders_products_order_id ON orders_products USING btree (order_id);


--
-- Name: fk__orders_products_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__orders_products_product_id ON orders_products USING btree (product_id);


--
-- Name: fk__plannings_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__plannings_customer_id ON plannings USING btree (customer_id);


--
-- Name: fk__plannings_order_array_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__plannings_order_array_id ON plannings USING btree (order_array_id);


--
-- Name: fk__plannings_tags_planning_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__plannings_tags_planning_id ON plannings_tags USING btree (planning_id);


--
-- Name: fk__plannings_tags_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__plannings_tags_tag_id ON plannings_tags USING btree (tag_id);


--
-- Name: fk__products_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__products_customer_id ON products USING btree (customer_id);


--
-- Name: fk__routes_planning_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__routes_planning_id ON routes USING btree (planning_id);


--
-- Name: fk__stops_route_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__stops_route_id ON stops USING btree (route_id);


--
-- Name: fk__stores_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__stores_customer_id ON stores USING btree (customer_id);


--
-- Name: fk__stores_vehicules_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__stores_vehicules_store_id ON stores_vehicules USING btree (store_id);


--
-- Name: fk__stores_vehicules_vehicle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__stores_vehicules_vehicle_id ON stores_vehicules USING btree (vehicle_id);


--
-- Name: fk__tags_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__tags_customer_id ON tags USING btree (customer_id);


--
-- Name: fk__users_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__users_customer_id ON users USING btree (customer_id);


--
-- Name: fk__users_layer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__users_layer_id ON users USING btree (layer_id);


--
-- Name: fk__vehicles_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__vehicles_customer_id ON vehicles USING btree (customer_id);


--
-- Name: fk__vehicles_router_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__vehicles_router_id ON vehicles USING btree (router_id);


--
-- Name: fk__zones_vehicle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__zones_vehicle_id ON zones USING btree (vehicle_id);


--
-- Name: fk__zones_zoning_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__zones_zoning_id ON zones USING btree (zoning_id);


--
-- Name: fk__zonings_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__zonings_customer_id ON zonings USING btree (customer_id);


--
-- Name: index_customers_on_job_destination_geocoding_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_job_destination_geocoding_id ON customers USING btree (job_destination_geocoding_id);


--
-- Name: index_customers_on_job_optimizer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_job_optimizer_id ON customers USING btree (job_optimizer_id);


--
-- Name: index_customers_on_job_store_geocoding_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_job_store_geocoding_id ON customers USING btree (job_store_geocoding_id);


--
-- Name: index_destinations_tags_on_destination_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_destinations_tags_on_destination_id ON destinations_tags USING btree (destination_id);


--
-- Name: index_destinations_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_destinations_tags_on_tag_id ON destinations_tags USING btree (tag_id);


--
-- Name: index_orders_on_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_visit_id ON orders USING btree (visit_id);


--
-- Name: index_plannings_on_vehicle_usage_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plannings_on_vehicle_usage_set_id ON plannings USING btree (vehicle_usage_set_id);


--
-- Name: index_plannings_zonings_on_planning_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plannings_zonings_on_planning_id ON plannings_zonings USING btree (planning_id);


--
-- Name: index_plannings_zonings_on_zoning_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plannings_zonings_on_zoning_id ON plannings_zonings USING btree (zoning_id);


--
-- Name: index_routes_on_vehicle_usage_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_routes_on_vehicle_usage_id ON routes USING btree (vehicle_usage_id);


--
-- Name: index_stops_on_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stops_on_visit_id ON stops USING btree (visit_id);


--
-- Name: index_tags_visits_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_visits_on_tag_id ON tags_visits USING btree (tag_id);


--
-- Name: index_tags_visits_on_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_visits_on_visit_id ON tags_visits USING btree (visit_id);


--
-- Name: index_users_on_api_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_api_key ON users USING btree (api_key);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_vehicle_usage_sets_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_usage_sets_on_customer_id ON vehicle_usage_sets USING btree (customer_id);


--
-- Name: index_vehicle_usage_sets_on_store_rest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_usage_sets_on_store_rest_id ON vehicle_usage_sets USING btree (store_rest_id);


--
-- Name: index_vehicle_usage_sets_on_store_start_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_usage_sets_on_store_start_id ON vehicle_usage_sets USING btree (store_start_id);


--
-- Name: index_vehicle_usage_sets_on_store_stop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_usage_sets_on_store_stop_id ON vehicle_usage_sets USING btree (store_stop_id);


--
-- Name: index_vehicle_usages_on_store_rest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_usages_on_store_rest_id ON vehicle_usages USING btree (store_rest_id);


--
-- Name: index_vehicle_usages_on_store_start_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_usages_on_store_start_id ON vehicle_usages USING btree (store_start_id);


--
-- Name: index_vehicle_usages_on_store_stop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_usages_on_store_stop_id ON vehicle_usages USING btree (store_stop_id);


--
-- Name: index_vehicle_usages_on_vehicle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_usages_on_vehicle_id ON vehicle_usages USING btree (vehicle_id);


--
-- Name: index_vehicle_usages_on_vehicle_usage_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_usages_on_vehicle_usage_set_id ON vehicle_usages USING btree (vehicle_usage_set_id);


--
-- Name: index_visits_on_destination_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_visits_on_destination_id ON visits USING btree (destination_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_destinations_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY destinations
    ADD CONSTRAINT fk_destinations_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;


--
-- Name: fk_order_arrays_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_arrays
    ADD CONSTRAINT fk_order_arrays_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;


--
-- Name: fk_orders_order_array_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_orders_order_array_id FOREIGN KEY (order_array_id) REFERENCES order_arrays(id) ON DELETE CASCADE;


--
-- Name: fk_orders_products_order_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders_products
    ADD CONSTRAINT fk_orders_products_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;


--
-- Name: fk_orders_products_product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders_products
    ADD CONSTRAINT fk_orders_products_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;


--
-- Name: fk_plannings_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plannings
    ADD CONSTRAINT fk_plannings_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;


--
-- Name: fk_plannings_order_array_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plannings
    ADD CONSTRAINT fk_plannings_order_array_id FOREIGN KEY (order_array_id) REFERENCES order_arrays(id);


--
-- Name: fk_plannings_tags_planning_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plannings_tags
    ADD CONSTRAINT fk_plannings_tags_planning_id FOREIGN KEY (planning_id) REFERENCES plannings(id) ON DELETE CASCADE;


--
-- Name: fk_plannings_tags_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plannings_tags
    ADD CONSTRAINT fk_plannings_tags_tag_id FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;


--
-- Name: fk_products_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT fk_products_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;


--
-- Name: fk_rails_16cc08e76b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usage_sets
    ADD CONSTRAINT fk_rails_16cc08e76b FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: fk_rails_19ac2e0237; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usage_sets
    ADD CONSTRAINT fk_rails_19ac2e0237 FOREIGN KEY (store_start_id) REFERENCES stores(id);


--
-- Name: fk_rails_2494c76b6d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usages
    ADD CONSTRAINT fk_rails_2494c76b6d FOREIGN KEY (vehicle_usage_set_id) REFERENCES vehicle_usage_sets(id);


--
-- Name: fk_rails_31b67ddbf0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usages
    ADD CONSTRAINT fk_rails_31b67ddbf0 FOREIGN KEY (store_stop_id) REFERENCES stores(id);


--
-- Name: fk_rails_5095b21bc2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT fk_rails_5095b21bc2 FOREIGN KEY (profile_id) REFERENCES profiles(id);


--
-- Name: fk_rails_5699cfb483; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT fk_rails_5699cfb483 FOREIGN KEY (vehicle_usage_id) REFERENCES vehicle_usages(id);


--
-- Name: fk_rails_5966cbef79; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY visits
    ADD CONSTRAINT fk_rails_5966cbef79 FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE;


--
-- Name: fk_rails_596f74dea1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_596f74dea1 FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE CASCADE;


--
-- Name: fk_rails_6652f557f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stops
    ADD CONSTRAINT fk_rails_6652f557f6 FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE CASCADE;


--
-- Name: fk_rails_6b54d8ec86; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usages
    ADD CONSTRAINT fk_rails_6b54d8ec86 FOREIGN KEY (vehicle_id) REFERENCES vehicles(id);


--
-- Name: fk_rails_7067840dd6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usage_sets
    ADD CONSTRAINT fk_rails_7067840dd6 FOREIGN KEY (store_rest_id) REFERENCES stores(id);


--
-- Name: fk_rails_75896d65fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usages
    ADD CONSTRAINT fk_rails_75896d65fc FOREIGN KEY (store_rest_id) REFERENCES stores(id);


--
-- Name: fk_rails_87008b08a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plannings_zonings
    ADD CONSTRAINT fk_rails_87008b08a3 FOREIGN KEY (planning_id) REFERENCES plannings(id) ON DELETE CASCADE;


--
-- Name: fk_rails_921d431096; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags_visits
    ADD CONSTRAINT fk_rails_921d431096 FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;


--
-- Name: fk_rails_c4685d96c0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plannings_zonings
    ADD CONSTRAINT fk_rails_c4685d96c0 FOREIGN KEY (zoning_id) REFERENCES zonings(id) ON DELETE CASCADE;


--
-- Name: fk_rails_cdf3e8f319; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usages
    ADD CONSTRAINT fk_rails_cdf3e8f319 FOREIGN KEY (store_start_id) REFERENCES stores(id);


--
-- Name: fk_rails_d5309e7b50; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags_visits
    ADD CONSTRAINT fk_rails_d5309e7b50 FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE CASCADE;


--
-- Name: fk_rails_d7d57d2bd1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY destinations_tags
    ADD CONSTRAINT fk_rails_d7d57d2bd1 FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;


--
-- Name: fk_rails_d7ffafb662; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicle_usage_sets
    ADD CONSTRAINT fk_rails_d7ffafb662 FOREIGN KEY (store_stop_id) REFERENCES stores(id);


--
-- Name: fk_rails_f0e748b80c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plannings
    ADD CONSTRAINT fk_rails_f0e748b80c FOREIGN KEY (vehicle_usage_set_id) REFERENCES vehicle_usage_sets(id);


--
-- Name: fk_rails_fde8fb742c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY destinations_tags
    ADD CONSTRAINT fk_rails_fde8fb742c FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE;


--
-- Name: fk_routes_planning_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT fk_routes_planning_id FOREIGN KEY (planning_id) REFERENCES plannings(id) ON DELETE CASCADE;


--
-- Name: fk_stops_route_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stops
    ADD CONSTRAINT fk_stops_route_id FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE;


--
-- Name: fk_stores_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT fk_stores_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;


--
-- Name: fk_stores_vehicules_store_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores_vehicules
    ADD CONSTRAINT fk_stores_vehicules_store_id FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE;


--
-- Name: fk_stores_vehicules_vehicle_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores_vehicules
    ADD CONSTRAINT fk_stores_vehicules_vehicle_id FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE;


--
-- Name: fk_tags_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT fk_tags_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;


--
-- Name: fk_users_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_users_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: fk_users_layer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_users_layer_id FOREIGN KEY (layer_id) REFERENCES layers(id);


--
-- Name: fk_vehicles_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicles
    ADD CONSTRAINT fk_vehicles_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;


--
-- Name: fk_vehicles_router_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicles
    ADD CONSTRAINT fk_vehicles_router_id FOREIGN KEY (router_id) REFERENCES routers(id);


--
-- Name: fk_zones_vehicle_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zones
    ADD CONSTRAINT fk_zones_vehicle_id FOREIGN KEY (vehicle_id) REFERENCES vehicles(id);


--
-- Name: fk_zones_zoning_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zones
    ADD CONSTRAINT fk_zones_zoning_id FOREIGN KEY (zoning_id) REFERENCES zonings(id) ON DELETE CASCADE;


--
-- Name: fk_zonings_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zonings
    ADD CONSTRAINT fk_zonings_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20130807195925');

INSERT INTO schema_migrations (version) VALUES ('20130807195929');

INSERT INTO schema_migrations (version) VALUES ('20130807195934');

INSERT INTO schema_migrations (version) VALUES ('20130807195940');

INSERT INTO schema_migrations (version) VALUES ('20130807195946');

INSERT INTO schema_migrations (version) VALUES ('20130807195950');

INSERT INTO schema_migrations (version) VALUES ('20130807195955');

INSERT INTO schema_migrations (version) VALUES ('20130807200001');

INSERT INTO schema_migrations (version) VALUES ('20130807200016');

INSERT INTO schema_migrations (version) VALUES ('20130807200021');

INSERT INTO schema_migrations (version) VALUES ('20130807200039');

INSERT INTO schema_migrations (version) VALUES ('20130807211354');

INSERT INTO schema_migrations (version) VALUES ('20130808183130');

INSERT INTO schema_migrations (version) VALUES ('20130808210830');

INSERT INTO schema_migrations (version) VALUES ('20130820202344');

INSERT INTO schema_migrations (version) VALUES ('20130825123959');

INSERT INTO schema_migrations (version) VALUES ('20130930201835');

INSERT INTO schema_migrations (version) VALUES ('20130930201836');

INSERT INTO schema_migrations (version) VALUES ('20131012124400');

INSERT INTO schema_migrations (version) VALUES ('20131015182755');

INSERT INTO schema_migrations (version) VALUES ('20131222105022');

INSERT INTO schema_migrations (version) VALUES ('20131222174504');

INSERT INTO schema_migrations (version) VALUES ('20131227135405');

INSERT INTO schema_migrations (version) VALUES ('20131228174827');

INSERT INTO schema_migrations (version) VALUES ('20140103161315');

INSERT INTO schema_migrations (version) VALUES ('20140207112148');

INSERT INTO schema_migrations (version) VALUES ('20140315155331');

INSERT INTO schema_migrations (version) VALUES ('20140601115136');

INSERT INTO schema_migrations (version) VALUES ('20140717114641');

INSERT INTO schema_migrations (version) VALUES ('20140721160736');

INSERT INTO schema_migrations (version) VALUES ('20140816112958');

INSERT INTO schema_migrations (version) VALUES ('20140816113900');

INSERT INTO schema_migrations (version) VALUES ('20140820163401');

INSERT INTO schema_migrations (version) VALUES ('20140821142548');

INSERT INTO schema_migrations (version) VALUES ('20140826131538');

INSERT INTO schema_migrations (version) VALUES ('20140903151616');

INSERT INTO schema_migrations (version) VALUES ('20140911144221');

INSERT INTO schema_migrations (version) VALUES ('20140917145632');

INSERT INTO schema_migrations (version) VALUES ('20140919125039');

INSERT INTO schema_migrations (version) VALUES ('20140926130501');

INSERT INTO schema_migrations (version) VALUES ('20140930130558');

INSERT INTO schema_migrations (version) VALUES ('20141002125341');

INSERT INTO schema_migrations (version) VALUES ('20141006140959');

INSERT INTO schema_migrations (version) VALUES ('20141014092855');

INSERT INTO schema_migrations (version) VALUES ('20141015093756');

INSERT INTO schema_migrations (version) VALUES ('20141021085750');

INSERT INTO schema_migrations (version) VALUES ('20141028150022');

INSERT INTO schema_migrations (version) VALUES ('20141028165002');

INSERT INTO schema_migrations (version) VALUES ('20141210144628');

INSERT INTO schema_migrations (version) VALUES ('20141210144629');

INSERT INTO schema_migrations (version) VALUES ('20141216163507');

INSERT INTO schema_migrations (version) VALUES ('20150108103218');

INSERT INTO schema_migrations (version) VALUES ('20150109130251');

INSERT INTO schema_migrations (version) VALUES ('20150121150634');

INSERT INTO schema_migrations (version) VALUES ('20150209173255');

INSERT INTO schema_migrations (version) VALUES ('20150216164130');

INSERT INTO schema_migrations (version) VALUES ('20150225160957');

INSERT INTO schema_migrations (version) VALUES ('20150226142752');

INSERT INTO schema_migrations (version) VALUES ('20150226143646');

INSERT INTO schema_migrations (version) VALUES ('20150309125918');

INSERT INTO schema_migrations (version) VALUES ('20150318172400');

INSERT INTO schema_migrations (version) VALUES ('20150328151059');

INSERT INTO schema_migrations (version) VALUES ('20150411114213');

INSERT INTO schema_migrations (version) VALUES ('20150411191047');

INSERT INTO schema_migrations (version) VALUES ('20150413102143');

INSERT INTO schema_migrations (version) VALUES ('20150414091637');

INSERT INTO schema_migrations (version) VALUES ('20150430120526');

INSERT INTO schema_migrations (version) VALUES ('20150505123132');

INSERT INTO schema_migrations (version) VALUES ('20150505145002');

INSERT INTO schema_migrations (version) VALUES ('20150630115249');

INSERT INTO schema_migrations (version) VALUES ('20150708163226');

INSERT INTO schema_migrations (version) VALUES ('20150710144116');

INSERT INTO schema_migrations (version) VALUES ('20150715120003');

INSERT INTO schema_migrations (version) VALUES ('20150722083814');

INSERT INTO schema_migrations (version) VALUES ('20150724091415');

INSERT INTO schema_migrations (version) VALUES ('20150803134100');

INSERT INTO schema_migrations (version) VALUES ('20150806133149');

INSERT INTO schema_migrations (version) VALUES ('20150812162637');

INSERT INTO schema_migrations (version) VALUES ('20150813154143');

INSERT INTO schema_migrations (version) VALUES ('20150814084849');

INSERT INTO schema_migrations (version) VALUES ('20150814165916');

INSERT INTO schema_migrations (version) VALUES ('20150818110546');

INSERT INTO schema_migrations (version) VALUES ('20150821152256');

INSERT INTO schema_migrations (version) VALUES ('20150827161221');

INSERT INTO schema_migrations (version) VALUES ('20150917130606');

INSERT INTO schema_migrations (version) VALUES ('20150924095144');

INSERT INTO schema_migrations (version) VALUES ('20150924152721');

INSERT INTO schema_migrations (version) VALUES ('20151001124324');

INSERT INTO schema_migrations (version) VALUES ('20151009165039');

INSERT INTO schema_migrations (version) VALUES ('20151012140724');

INSERT INTO schema_migrations (version) VALUES ('20151013142817');

INSERT INTO schema_migrations (version) VALUES ('20151013142818');

INSERT INTO schema_migrations (version) VALUES ('20151014131247');

INSERT INTO schema_migrations (version) VALUES ('20151021141140');

INSERT INTO schema_migrations (version) VALUES ('20151026165111');

INSERT INTO schema_migrations (version) VALUES ('20151027103159');

INSERT INTO schema_migrations (version) VALUES ('20151102113505');

INSERT INTO schema_migrations (version) VALUES ('20151102142302');

INSERT INTO schema_migrations (version) VALUES ('20151110095624');

INSERT INTO schema_migrations (version) VALUES ('20151118172552');

INSERT INTO schema_migrations (version) VALUES ('20151118172553');

INSERT INTO schema_migrations (version) VALUES ('20151118172554');

INSERT INTO schema_migrations (version) VALUES ('20151123104347');

INSERT INTO schema_migrations (version) VALUES ('20151127174934');

INSERT INTO schema_migrations (version) VALUES ('20151203174336');

INSERT INTO schema_migrations (version) VALUES ('20151207111057');

INSERT INTO schema_migrations (version) VALUES ('20151210121421');

INSERT INTO schema_migrations (version) VALUES ('20151211140402');

INSERT INTO schema_migrations (version) VALUES ('20151215150205');

INSERT INTO schema_migrations (version) VALUES ('20160105154207');

INSERT INTO schema_migrations (version) VALUES ('20160108154328');

INSERT INTO schema_migrations (version) VALUES ('20160111102326');

INSERT INTO schema_migrations (version) VALUES ('20160125093540');

INSERT INTO schema_migrations (version) VALUES ('20160128105941');

INSERT INTO schema_migrations (version) VALUES ('20160128170155');

INSERT INTO schema_migrations (version) VALUES ('20160129081114');

INSERT INTO schema_migrations (version) VALUES ('20160129160000');

INSERT INTO schema_migrations (version) VALUES ('20160201165009');

INSERT INTO schema_migrations (version) VALUES ('20160201165010');

INSERT INTO schema_migrations (version) VALUES ('20160208083631');

INSERT INTO schema_migrations (version) VALUES ('20160224095842');

INSERT INTO schema_migrations (version) VALUES ('20160225160902');

INSERT INTO schema_migrations (version) VALUES ('20160229111113');

INSERT INTO schema_migrations (version) VALUES ('20160229132719');

INSERT INTO schema_migrations (version) VALUES ('20160301113027');

INSERT INTO schema_migrations (version) VALUES ('20160302112451');

INSERT INTO schema_migrations (version) VALUES ('20160309170226');

INSERT INTO schema_migrations (version) VALUES ('20160310093440');

INSERT INTO schema_migrations (version) VALUES ('20160311104210');

INSERT INTO schema_migrations (version) VALUES ('20160314100318');

INSERT INTO schema_migrations (version) VALUES ('20160315102718');

INSERT INTO schema_migrations (version) VALUES ('20160317114628');

INSERT INTO schema_migrations (version) VALUES ('20160325113705');

INSERT INTO schema_migrations (version) VALUES ('20160401092143');

INSERT INTO schema_migrations (version) VALUES ('20160406140606');

INSERT INTO schema_migrations (version) VALUES ('20160413130004');

INSERT INTO schema_migrations (version) VALUES ('20160414093809');

INSERT INTO schema_migrations (version) VALUES ('20160414142500');

INSERT INTO schema_migrations (version) VALUES ('20160415094723');

INSERT INTO schema_migrations (version) VALUES ('20160509132447');

INSERT INTO schema_migrations (version) VALUES ('20160530145107');

INSERT INTO schema_migrations (version) VALUES ('20160617091911');

INSERT INTO schema_migrations (version) VALUES ('20160704124035');

INSERT INTO schema_migrations (version) VALUES ('20160708085953');

INSERT INTO schema_migrations (version) VALUES ('20160720144957');

