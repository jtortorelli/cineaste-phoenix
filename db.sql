--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: actor_group_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE actor_group_roles (
    film_id uuid,
    group_id uuid,
    roles character varying(255)[] NOT NULL,
    "order" integer DEFAULT 99
);


ALTER TABLE actor_group_roles OWNER TO postgres;

--
-- Name: actor_person_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE actor_person_roles (
    film_id uuid,
    person_id uuid,
    roles character varying(255)[] NOT NULL,
    "order" integer DEFAULT 99
);


ALTER TABLE actor_person_roles OWNER TO postgres;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE groups (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    showcase boolean DEFAULT false NOT NULL,
    active_start integer,
    active_end integer,
    props jsonb
);


ALTER TABLE groups OWNER TO postgres;

--
-- Name: people; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE people (
    id uuid NOT NULL,
    given_name character varying(255) NOT NULL,
    family_name character varying(255) NOT NULL,
    gender character varying(255) DEFAULT 'U'::character varying NOT NULL,
    showcase boolean DEFAULT false NOT NULL,
    dob jsonb,
    dod jsonb,
    birth_place character varying(255),
    death_place character varying(255),
    aliases character varying(255)[],
    other_names jsonb
);


ALTER TABLE people OWNER TO postgres;

--
-- Name: film_cast_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW film_cast_view AS
 SELECT r.film_id,
    p.id AS entity_id,
    r.roles,
    r."order",
    p.showcase,
    'person'::text AS type,
    jsonb_build_object('display_name', (((p.given_name)::text || ' '::text) || (p.family_name)::text), 'sort_name', (((p.family_name)::text || ' '::text) || (p.given_name)::text)) AS names
   FROM (actor_person_roles r
     JOIN people p ON ((p.id = r.person_id)))
UNION
 SELECT r.film_id,
    g.id AS entity_id,
    r.roles,
    r."order",
    g.showcase,
    'group'::text AS type,
    jsonb_build_object('display_name', g.name, 'sort_name', regexp_replace((g.name)::text, '^The '::text, ''::text)) AS names
   FROM (actor_group_roles r
     JOIN groups g ON ((g.id = r.group_id)));


ALTER TABLE film_cast_view OWNER TO postgres;

--
-- Name: film_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE film_images (
    film_id uuid NOT NULL,
    type character varying(255) NOT NULL,
    file_name character varying(255) NOT NULL,
    caption character varying(255)
);


ALTER TABLE film_images OWNER TO postgres;

--
-- Name: films; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE films (
    id uuid NOT NULL,
    title character varying(255) NOT NULL,
    release_date date NOT NULL,
    duration integer,
    showcase boolean DEFAULT false NOT NULL,
    aliases character varying(255)[],
    props jsonb
);


ALTER TABLE films OWNER TO postgres;

--
-- Name: film_index_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW film_index_view AS
 SELECT films.id,
    films.title,
    (date_part('year'::text, films.release_date))::integer AS year,
    films.aliases
   FROM films
  WHERE (films.showcase = true);


ALTER TABLE film_index_view OWNER TO postgres;

--
-- Name: staff_person_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE staff_person_roles (
    film_id uuid,
    person_id uuid,
    role character varying(255) NOT NULL,
    "order" integer DEFAULT 99
);


ALTER TABLE staff_person_roles OWNER TO postgres;

--
-- Name: film_staff_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW film_staff_view AS
 SELECT r.film_id,
    r.role,
    array_agg(json_build_object('person_id', p.id, 'name', (((p.given_name)::text || ' '::text) || (p.family_name)::text), 'showcase', p.showcase, 'type', 'person', 'order', r."order")) AS staff
   FROM (staff_person_roles r
     JOIN people p ON ((p.id = r.person_id)))
  GROUP BY r.film_id, r.role;


ALTER TABLE film_staff_view OWNER TO postgres;

--
-- Name: group_memberships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE group_memberships (
    group_id uuid,
    person_id uuid
);


ALTER TABLE group_memberships OWNER TO postgres;

--
-- Name: group_roles_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW group_roles_view AS
 SELECT f.title AS film_title,
    f.release_date AS film_release_date,
    f.showcase AS film_showcase,
    f.id AS film_id,
    'Actor'::text AS role,
    r.roles AS characters,
    g.id AS group_id
   FROM ((actor_group_roles r
     JOIN films f ON ((f.id = r.film_id)))
     JOIN groups g ON ((g.id = r.group_id)))
  ORDER BY g.id, 'Actor'::text, f.release_date;


ALTER TABLE group_roles_view OWNER TO postgres;

--
-- Name: person_roles_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW person_roles_view AS
 SELECT f.title AS film_title,
    f.release_date AS film_release_date,
    f.showcase AS film_showcase,
    f.id AS film_id,
    r.role,
    NULL::character varying[] AS characters,
    p.id AS person_id
   FROM ((staff_person_roles r
     JOIN films f ON ((f.id = r.film_id)))
     JOIN people p ON ((p.id = r.person_id)))
UNION
 SELECT f.title AS film_title,
    f.release_date AS film_release_date,
    f.showcase AS film_showcase,
    f.id AS film_id,
    'Actor'::character varying AS role,
    r.roles AS characters,
    p.id AS person_id
   FROM ((actor_person_roles r
     JOIN films f ON ((f.id = r.film_id)))
     JOIN people p ON ((p.id = r.person_id)))
  ORDER BY 7, 5, 2;


ALTER TABLE person_roles_view OWNER TO postgres;

--
-- Name: people_index_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW people_index_view AS
 SELECT p.id,
    'person'::text AS type,
    p.gender,
    (((p.family_name)::text || ' '::text) || (p.given_name)::text) AS sort_name,
    ARRAY[p.family_name, p.given_name] AS display_name,
    p.aliases,
    ( SELECT ARRAY( SELECT prv.role
                   FROM person_roles_view prv
                  WHERE (p.id = prv.person_id)
                  GROUP BY prv.role
                  ORDER BY (count(*)) DESC
                 LIMIT 3) AS "array") AS roles
   FROM people p
  WHERE (p.showcase = true)
UNION
 SELECT g.id,
    'group'::text AS type,
    NULL::character varying AS gender,
    regexp_replace((g.name)::text, '^The '::text, ''::text) AS sort_name,
    ARRAY[g.name] AS display_name,
    NULL::character varying[] AS aliases,
    ( SELECT ARRAY( SELECT grv.role
                   FROM group_roles_view grv
                  WHERE (g.id = grv.group_id)
                  GROUP BY grv.role
                  ORDER BY (count(*)) DESC
                 LIMIT 3) AS "array") AS roles
   FROM groups g
  WHERE (g.showcase = true);


ALTER TABLE people_index_view OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


ALTER TABLE schema_migrations OWNER TO postgres;

--
-- Name: series; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE series (
    id uuid NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE series OWNER TO postgres;

--
-- Name: series_films; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE series_films (
    series_id uuid,
    film_id uuid,
    "order" integer NOT NULL
);


ALTER TABLE series_films OWNER TO postgres;

--
-- Name: studio_films; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE studio_films (
    studio_id uuid,
    film_id uuid
);


ALTER TABLE studio_films OWNER TO postgres;

--
-- Name: studios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE studios (
    id uuid NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE studios OWNER TO postgres;

--
-- Data for Name: actor_group_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY actor_group_roles (film_id, group_id, roles, "order") FROM stdin;
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	5bbcef55-15b8-4fc1-a507-a115d57bfbbf	{"The Shobijin"}	4
75bb901c-e41c-494f-aae8-7a5282f3bf96	5bbcef55-15b8-4fc1-a507-a115d57bfbbf	{"The Shobijin"}	6
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	5bbcef55-15b8-4fc1-a507-a115d57bfbbf	{"The Shobijin"}	5
f474852a-cc25-477d-a7b9-06aa688f7fb2	660408b0-763e-451b-a3de-51cad893c087	{"The Shobijin"}	27
\.


--
-- Data for Name: actor_person_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY actor_person_roles (film_id, person_id, roles, "order") FROM stdin;
7f9c68a7-8cec-4f4e-be97-528fe66605c3	34de1ef2-9428-4c7e-8512-5683f7cced38	{Tsukioka}	1
7f9c68a7-8cec-4f4e-be97-528fe66605c3	fae6c562-be36-496b-acdb-889a433773cc	{"Hidemi Yamaji"}	2
7f9c68a7-8cec-4f4e-be97-528fe66605c3	20079bf2-7dc2-4e24-83bc-16f43af26cc6	{Kobayashi}	3
7f9c68a7-8cec-4f4e-be97-528fe66605c3	bd14a659-bf60-4b65-9ec2-514bad9ccb72	{"Dr. Kyohei Yamane"}	4
7f9c68a7-8cec-4f4e-be97-528fe66605c3	3b4f6a36-44b7-4b23-af88-d03beec21e4d	{"Dr. Tadokoro"}	5
7f9c68a7-8cec-4f4e-be97-528fe66605c3	468e289d-6838-4fb7-b710-7b47a209e5d0	{"Captain Terasawa"}	6
7f9c68a7-8cec-4f4e-be97-528fe66605c3	06adecc6-cbbe-4893-a916-16e683448590	{Tajima}	8
7f9c68a7-8cec-4f4e-be97-528fe66605c3	922bb3b7-bee1-45e6-bcd0-524336747977	{Yasuko}	9
7f9c68a7-8cec-4f4e-be97-528fe66605c3	aa83b831-f8ba-42af-95d0-fab1c9755bbc	{"Defense Secretary"}	10
7f9c68a7-8cec-4f4e-be97-528fe66605c3	65abafc9-9dce-440e-adcf-cd8ae728c7eb	{"Mr. Yamaji"}	11
7f9c68a7-8cec-4f4e-be97-528fe66605c3	f79f33f2-2385-49c8-9c63-e6c118835713	{"Escaped Convict"}	12
7f9c68a7-8cec-4f4e-be97-528fe66605c3	56679376-b60c-4926-ae33-3c99ae021778	{Ikeda}	13
7f9c68a7-8cec-4f4e-be97-528fe66605c3	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{"Escaped Convict"}	14
7f9c68a7-8cec-4f4e-be97-528fe66605c3	600f3ec6-2ba2-4c6d-8cc1-01f4d625755b	{"Police Chief"}	16
7f9c68a7-8cec-4f4e-be97-528fe66605c3	acace893-b445-4425-98d9-09126f7dcbf6	{"Escaped Convict"}	17
7f9c68a7-8cec-4f4e-be97-528fe66605c3	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"Escaped Convict"}	18
7f9c68a7-8cec-4f4e-be97-528fe66605c3	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{"Escaped Convict"}	20
7f9c68a7-8cec-4f4e-be97-528fe66605c3	f5b35e44-efd4-4298-8124-4bccd4325e23	{Anguirus}	22
7f9c68a7-8cec-4f4e-be97-528fe66605c3	9b787e61-5c06-463d-aa62-18c142735fc8	{Godzilla}	23
7f9c68a7-8cec-4f4e-be97-528fe66605c3	3bd1857e-4894-4469-82da-e4f5f6c49a1a	{"Nightclub Singer"}	24
7f9c68a7-8cec-4f4e-be97-528fe66605c3	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Policeman}	99
7f9c68a7-8cec-4f4e-be97-528fe66605c3	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{Assistant}	99
7f9c68a7-8cec-4f4e-be97-528fe66605c3	f38a2a42-a836-4c62-a1d5-265cba51076b	{Soldier}	99
7f9c68a7-8cec-4f4e-be97-528fe66605c3	99d628a5-b63c-4bf4-ae4e-1290b618f02f	{Policeman}	99
79a16ff9-c72a-4dd0-ba4e-67f578e97682	8880384d-16f9-4e12-b9c2-708c2ecaa93a	{Nanjo}	1
79a16ff9-c72a-4dd0-ba4e-67f578e97682	97fb5fee-4d35-45d7-8438-93a364a5135d	{Michiyo}	2
79a16ff9-c72a-4dd0-ba4e-67f578e97682	def945ba-826b-4d5a-b100-ce9eb2362805	{Yajima}	3
79a16ff9-c72a-4dd0-ba4e-67f578e97682	06adecc6-cbbe-4893-a916-16e683448590	{Komatsu}	4
79a16ff9-c72a-4dd0-ba4e-67f578e97682	e521b82f-a0e4-4d30-911f-92cba2058dfc	{Ken}	5
79a16ff9-c72a-4dd0-ba4e-67f578e97682	9c7cc495-89cb-4892-8d6f-0308ac4b1c54	{"Mari's Grandfather"}	6
79a16ff9-c72a-4dd0-ba4e-67f578e97682	3881d7da-94c0-408b-b384-1133f2c55f46	{"Newspaper Editor"}	7
79a16ff9-c72a-4dd0-ba4e-67f578e97682	d901ee22-34f3-4dc0-8c93-2362b57387a2	{Scientist}	8
79a16ff9-c72a-4dd0-ba4e-67f578e97682	23034690-67d2-4b91-a857-a04f9f810deb	{Parliamentarian}	9
79a16ff9-c72a-4dd0-ba4e-67f578e97682	468e289d-6838-4fb7-b710-7b47a209e5d0	{Commissioner}	10
79a16ff9-c72a-4dd0-ba4e-67f578e97682	505a2aab-1965-4e16-a6b4-697e14d85d1a	{"Food Stand Chef"}	24
79a16ff9-c72a-4dd0-ba4e-67f578e97682	2f7a44eb-826b-477e-973b-5c57a715b25a	{"Nightclub Patron"}	25
79a16ff9-c72a-4dd0-ba4e-67f578e97682	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Reporter}	99
79a16ff9-c72a-4dd0-ba4e-67f578e97682	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{"Bus Passenger"}	99
79a16ff9-c72a-4dd0-ba4e-67f578e97682	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{"Police Chief"}	11
79a16ff9-c72a-4dd0-ba4e-67f578e97682	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Newsreader}	27
79a16ff9-c72a-4dd0-ba4e-67f578e97682	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{"Bus Driver",Detective}	99
79a16ff9-c72a-4dd0-ba4e-67f578e97682	e68b3a04-1efc-43ab-8bf3-1bf60eb72014	{Mari}	13
79a16ff9-c72a-4dd0-ba4e-67f578e97682	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{Policeman}	28
79a16ff9-c72a-4dd0-ba4e-67f578e97682	ba759075-8927-42c2-8da7-58086e6f1e27	{Waiter}	99
79a16ff9-c72a-4dd0-ba4e-67f578e97682	b08c8645-13e0-4392-b01e-3d1d069d60ae	{"Yajima's Henchman"}	14
79a16ff9-c72a-4dd0-ba4e-67f578e97682	c21e21a8-e940-417c-982e-33aacb5e19a7	{"Jewelry Store Clerk"}	29
79a16ff9-c72a-4dd0-ba4e-67f578e97682	885202f7-ebc0-41e6-91c8-761c1b65593a	{"Yajima's Henchman"}	15
79a16ff9-c72a-4dd0-ba4e-67f578e97682	0e2de731-55a7-44be-a0b3-8213183d631e	{Parliamentarian}	30
79a16ff9-c72a-4dd0-ba4e-67f578e97682	707ffa12-afe9-4ea9-b269-5c40f47d0620	{"Yajima's Henchman"}	18
79a16ff9-c72a-4dd0-ba4e-67f578e97682	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Driver}	32
79a16ff9-c72a-4dd0-ba4e-67f578e97682	9e5948a3-3002-44bf-912e-5902e5f385f1	{Parliamentarian}	21
79a16ff9-c72a-4dd0-ba4e-67f578e97682	f38a2a42-a836-4c62-a1d5-265cba51076b	{Policeman}	33
79a16ff9-c72a-4dd0-ba4e-67f578e97682	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{"Bus Passenger","Nightclub Mascot"}	22
79a16ff9-c72a-4dd0-ba4e-67f578e97682	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Detective,"Bus Passenger"}	99
79a16ff9-c72a-4dd0-ba4e-67f578e97682	9b787e61-5c06-463d-aa62-18c142735fc8	{"Suicidal Invisible Man"}	23
79a16ff9-c72a-4dd0-ba4e-67f578e97682	c0aaff10-a67a-4304-a3c3-875a00348870	{Detective,"Bus Passenger"}	99
56dab76c-fc4d-4547-b2fe-3a743154f1d5	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Shigeru Kawamura"}	1
56dab76c-fc4d-4547-b2fe-3a743154f1d5	ba66d21c-9c9a-4290-848e-a89f3a2ce28d	{Kiyo}	2
56dab76c-fc4d-4547-b2fe-3a743154f1d5	1e6ae6ba-b28a-4a9b-97a9-2374c016d267	{"Chief Nishimura"}	3
56dab76c-fc4d-4547-b2fe-3a743154f1d5	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Dr. Kashiwagi"}	4
56dab76c-fc4d-4547-b2fe-3a743154f1d5	3881d7da-94c0-408b-b384-1133f2c55f46	{"Dr. Minami"}	5
56dab76c-fc4d-4547-b2fe-3a743154f1d5	aa83b831-f8ba-42af-95d0-fab1c9755bbc	{"Mining Chief Osaki"}	7
56dab76c-fc4d-4547-b2fe-3a743154f1d5	86209caa-4d37-4745-be23-dbee24bf244a	{Izeki}	8
56dab76c-fc4d-4547-b2fe-3a743154f1d5	b08c8645-13e0-4392-b01e-3d1d069d60ae	{"Dr. Hayama"}	10
56dab76c-fc4d-4547-b2fe-3a743154f1d5	e82833e4-7eee-4ef1-88e5-a285946593aa	{Tsuda}	12
56dab76c-fc4d-4547-b2fe-3a743154f1d5	46232c4d-423c-40eb-941d-087f6a1d0643	{"Air Force Commander"}	15
56dab76c-fc4d-4547-b2fe-3a743154f1d5	f9221586-cca1-42ce-82c9-310042ffe9fe	{"Dr. Sunagawa"}	16
56dab76c-fc4d-4547-b2fe-3a743154f1d5	b883c489-0fe7-4165-86a4-49b531a28c37	{Goro}	20
56dab76c-fc4d-4547-b2fe-3a743154f1d5	f38a2a42-a836-4c62-a1d5-265cba51076b	{Miner}	21
56dab76c-fc4d-4547-b2fe-3a743154f1d5	0e2de731-55a7-44be-a0b3-8213183d631e	{Policeman}	22
56dab76c-fc4d-4547-b2fe-3a743154f1d5	c0aaff10-a67a-4304-a3c3-875a00348870	{"Air Force Officer"}	24
56dab76c-fc4d-4547-b2fe-3a743154f1d5	2f7a44eb-826b-477e-973b-5c57a715b25a	{"Air Force Officer"}	25
7f9c68a7-8cec-4f4e-be97-528fe66605c3	9e5948a3-3002-44bf-912e-5902e5f385f1	{"Fishing Company Employee"}	15
56dab76c-fc4d-4547-b2fe-3a743154f1d5	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{Meganulon,Pilot}	30
56dab76c-fc4d-4547-b2fe-3a743154f1d5	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{Reporter}	34
56dab76c-fc4d-4547-b2fe-3a743154f1d5	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Reporter}	35
56dab76c-fc4d-4547-b2fe-3a743154f1d5	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Pilot}	36
56dab76c-fc4d-4547-b2fe-3a743154f1d5	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Policeman}	41
56dab76c-fc4d-4547-b2fe-3a743154f1d5	c21e21a8-e940-417c-982e-33aacb5e19a7	{Pilot}	45
56dab76c-fc4d-4547-b2fe-3a743154f1d5	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Miner}	49
56dab76c-fc4d-4547-b2fe-3a743154f1d5	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{"Air Force Officer","Police Chemist"}	51
56dab76c-fc4d-4547-b2fe-3a743154f1d5	65171b44-fd3a-4948-9613-3f7206141774	{Miner}	54
56dab76c-fc4d-4547-b2fe-3a743154f1d5	707ffa12-afe9-4ea9-b269-5c40f47d0620	{"Coal Car Staff"}	55
56dab76c-fc4d-4547-b2fe-3a743154f1d5	ba759075-8927-42c2-8da7-58086e6f1e27	{Policeman}	58
56dab76c-fc4d-4547-b2fe-3a743154f1d5	f5b35e44-efd4-4298-8124-4bccd4325e23	{Meganulon,"Hotel Manager"}	61
56dab76c-fc4d-4547-b2fe-3a743154f1d5	9b787e61-5c06-463d-aa62-18c142735fc8	{Soldier,Rodan}	62
56dab76c-fc4d-4547-b2fe-3a743154f1d5	56679376-b60c-4926-ae33-3c99ae021778	{Soldier}	99
56dab76c-fc4d-4547-b2fe-3a743154f1d5	5240cb5f-b0a8-4c64-aa01-93a65b45d419	{Newsreader}	99
ef4f2354-b764-4f5e-af66-813369a2520c	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Dr. Joji Atsumi"}	1
ef4f2354-b764-4f5e-af66-813369a2520c	ba66d21c-9c9a-4290-848e-a89f3a2ce28d	{"Etsuko Shiraishi"}	2
ef4f2354-b764-4f5e-af66-813369a2520c	9bf7c6b0-5a5f-485d-80e1-4fe6a1241bfd	{"Hiroko Iwamoto"}	3
ef4f2354-b764-4f5e-af66-813369a2520c	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Dr. Ryoichi Shiraishi"}	4
ef4f2354-b764-4f5e-af66-813369a2520c	bd14a659-bf60-4b65-9ec2-514bad9ccb72	{"Dr. Tanjiro Adachi"}	5
ef4f2354-b764-4f5e-af66-813369a2520c	b86678a4-b0f5-477d-af53-af0dde7e60ef	{"General Morita"}	6
ef4f2354-b764-4f5e-af66-813369a2520c	0b33ac7b-829f-4140-b760-74806280cf6a	{"Officer Seki"}	7
ef4f2354-b764-4f5e-af66-813369a2520c	67eeac93-8584-4ffd-a380-2ef1dbc83ee2	{"Officer Sugimoto"}	8
ef4f2354-b764-4f5e-af66-813369a2520c	3881d7da-94c0-408b-b384-1133f2c55f46	{"Dr. Kawanami"}	9
ef4f2354-b764-4f5e-af66-813369a2520c	06adecc6-cbbe-4893-a916-16e683448590	{"The Grand Mysterian"}	10
ef4f2354-b764-4f5e-af66-813369a2520c	8354c6a4-fa6b-4ac6-8f8a-d29ff1d1d3bb	{Translator}	13
ef4f2354-b764-4f5e-af66-813369a2520c	600f3ec6-2ba2-4c6d-8cc1-01f4d625755b	{Newsreader}	14
ef4f2354-b764-4f5e-af66-813369a2520c	d9b9fe70-61d5-477e-b927-453ab57591c9	{Villager}	15
ef4f2354-b764-4f5e-af66-813369a2520c	f79f33f2-2385-49c8-9c63-e6c118835713	{Villager}	16
ef4f2354-b764-4f5e-af66-813369a2520c	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{Policeman}	17
ef4f2354-b764-4f5e-af66-813369a2520c	46232c4d-423c-40eb-941d-087f6a1d0643	{"Military Officer"}	18
ef4f2354-b764-4f5e-af66-813369a2520c	20f64b6e-c968-4cf2-b195-76561d8acea6	{"Dr. Noda"}	19
ef4f2354-b764-4f5e-af66-813369a2520c	2f7a44eb-826b-477e-973b-5c57a715b25a	{Parliamentarian}	20
ef4f2354-b764-4f5e-af66-813369a2520c	0e2de731-55a7-44be-a0b3-8213183d631e	{Soldier}	23
ef4f2354-b764-4f5e-af66-813369a2520c	e82833e4-7eee-4ef1-88e5-a285946593aa	{Policeman}	24
ef4f2354-b764-4f5e-af66-813369a2520c	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{Detective}	25
ef4f2354-b764-4f5e-af66-813369a2520c	99d628a5-b63c-4bf4-ae4e-1290b618f02f	{Soldier}	26
ef4f2354-b764-4f5e-af66-813369a2520c	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{Policeman}	27
ef4f2354-b764-4f5e-af66-813369a2520c	b883c489-0fe7-4165-86a4-49b531a28c37	{Policeman}	28
ef4f2354-b764-4f5e-af66-813369a2520c	ecb241cd-e5e8-4239-a084-3fc522475618	{"Dr. Svenson"}	30
ef4f2354-b764-4f5e-af66-813369a2520c	fe24405b-2c4d-479e-8f0c-0233a656f259	{"Dr. DeGracia"}	31
ef4f2354-b764-4f5e-af66-813369a2520c	f9a23daa-fab8-418d-90f0-30a195ca171d	{Reporter}	99
ef4f2354-b764-4f5e-af66-813369a2520c	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Soldier}	99
ef4f2354-b764-4f5e-af66-813369a2520c	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Reporter}	99
ef4f2354-b764-4f5e-af66-813369a2520c	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Soldier,Policeman}	99
ef4f2354-b764-4f5e-af66-813369a2520c	f38a2a42-a836-4c62-a1d5-265cba51076b	{"Military Officer"}	99
ef4f2354-b764-4f5e-af66-813369a2520c	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Pilot}	99
ef4f2354-b764-4f5e-af66-813369a2520c	65171b44-fd3a-4948-9613-3f7206141774	{Policeman}	99
ef4f2354-b764-4f5e-af66-813369a2520c	c0aaff10-a67a-4304-a3c3-875a00348870	{Pilot}	99
ef4f2354-b764-4f5e-af66-813369a2520c	aa83b831-f8ba-42af-95d0-fab1c9755bbc	{"Defense Secretary"}	11
ef4f2354-b764-4f5e-af66-813369a2520c	f9221586-cca1-42ce-82c9-310042ffe9fe	{"Adachi's Assistant"}	21
ef4f2354-b764-4f5e-af66-813369a2520c	9b787e61-5c06-463d-aa62-18c142735fc8	{Mogera,Soldier}	32
ef4f2354-b764-4f5e-af66-813369a2520c	040d7f31-5c23-49df-9b69-d3fb78b6d93f	{"Dr. Koda"}	12
ef4f2354-b764-4f5e-af66-813369a2520c	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{Policeman}	22
ef4f2354-b764-4f5e-af66-813369a2520c	f5b35e44-efd4-4298-8124-4bccd4325e23	{Mogera}	33
132ec70b-0248-450e-9ae2-38c8245dc2e9	ba66d21c-9c9a-4290-848e-a89f3a2ce28d	{"Chikako Arai"}	1
132ec70b-0248-450e-9ae2-38c8245dc2e9	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Dr. Masada"}	2
132ec70b-0248-450e-9ae2-38c8245dc2e9	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Detective Tominaga"}	3
132ec70b-0248-450e-9ae2-38c8245dc2e9	bdd9d156-3b37-4094-b65a-162ce892674d	{"Detective Miyashita"}	4
132ec70b-0248-450e-9ae2-38c8245dc2e9	ba785322-fe4d-459b-b926-9fb2ed0f34ef	{"Dr. Maki"}	5
132ec70b-0248-450e-9ae2-38c8245dc2e9	7e735ef6-b865-424d-9291-0387716327cb	{Uchida}	6
132ec70b-0248-450e-9ae2-38c8245dc2e9	0b33ac7b-829f-4140-b760-74806280cf6a	{Misaki}	7
132ec70b-0248-450e-9ae2-38c8245dc2e9	06adecc6-cbbe-4893-a916-16e683448590	{"Detective Taguchi"}	9
132ec70b-0248-450e-9ae2-38c8245dc2e9	1fa4a84a-c542-4bec-acae-dc5cfffcbd2b	{Gangster}	11
132ec70b-0248-450e-9ae2-38c8245dc2e9	86209caa-4d37-4745-be23-dbee24bf244a	{"Detective Sakata"}	12
132ec70b-0248-450e-9ae2-38c8245dc2e9	040d7f31-5c23-49df-9b69-d3fb78b6d93f	{"Mr. Chin"}	13
132ec70b-0248-450e-9ae2-38c8245dc2e9	d9b9fe70-61d5-477e-b927-453ab57591c9	{Fisherman}	14
132ec70b-0248-450e-9ae2-38c8245dc2e9	f79f33f2-2385-49c8-9c63-e6c118835713	{Fisherman}	15
132ec70b-0248-450e-9ae2-38c8245dc2e9	41a0af3c-b4a2-443f-bdaa-7121df6fe056	{"Nightclub Dancer"}	16
132ec70b-0248-450e-9ae2-38c8245dc2e9	f03e5540-5215-405b-8641-1b3f60ebe755	{"Police Executive"}	17
132ec70b-0248-450e-9ae2-38c8245dc2e9	aa83b831-f8ba-42af-95d0-fab1c9755bbc	{"Police Executive"}	18
132ec70b-0248-450e-9ae2-38c8245dc2e9	387b5c1f-0e3a-4581-a4e1-26f64e412d52	{Nishiyama}	19
132ec70b-0248-450e-9ae2-38c8245dc2e9	56679376-b60c-4926-ae33-3c99ae021778	{Gangster}	20
132ec70b-0248-450e-9ae2-38c8245dc2e9	505a2aab-1965-4e16-a6b4-697e14d85d1a	{Fisherman}	21
132ec70b-0248-450e-9ae2-38c8245dc2e9	99d628a5-b63c-4bf4-ae4e-1290b618f02f	{"Detective Seki"}	22
132ec70b-0248-450e-9ae2-38c8245dc2e9	5e35fe94-1c41-4e60-a400-aa44c201deb1	{Bystander}	23
132ec70b-0248-450e-9ae2-38c8245dc2e9	6082d456-e1d7-43de-8174-148d1a2b09c0	{"Gangster Waiter"}	27
132ec70b-0248-450e-9ae2-38c8245dc2e9	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{"Taxi Driver"}	28
132ec70b-0248-450e-9ae2-38c8245dc2e9	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{Gangster}	29
132ec70b-0248-450e-9ae2-38c8245dc2e9	20f64b6e-c968-4cf2-b195-76561d8acea6	{"Police Executive"}	30
132ec70b-0248-450e-9ae2-38c8245dc2e9	2f7a44eb-826b-477e-973b-5c57a715b25a	{"Police Executive"}	31
132ec70b-0248-450e-9ae2-38c8245dc2e9	885202f7-ebc0-41e6-91c8-761c1b65593a	{"Informant Gangster"}	32
132ec70b-0248-450e-9ae2-38c8245dc2e9	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{"Detective Ogawa"}	33
132ec70b-0248-450e-9ae2-38c8245dc2e9	18fd187f-354e-4318-b6f1-71ac2b35e169	{Fisherman}	34
132ec70b-0248-450e-9ae2-38c8245dc2e9	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Soldier}	35
132ec70b-0248-450e-9ae2-38c8245dc2e9	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{Fireman}	36
132ec70b-0248-450e-9ae2-38c8245dc2e9	0e2de731-55a7-44be-a0b3-8213183d631e	{Soldier}	37
132ec70b-0248-450e-9ae2-38c8245dc2e9	e82833e4-7eee-4ef1-88e5-a285946593aa	{"Police Chemist"}	38
132ec70b-0248-450e-9ae2-38c8245dc2e9	9e5948a3-3002-44bf-912e-5902e5f385f1	{"Police Executive"}	39
132ec70b-0248-450e-9ae2-38c8245dc2e9	f5b35e44-efd4-4298-8124-4bccd4325e23	{"Fishing Captain"}	40
132ec70b-0248-450e-9ae2-38c8245dc2e9	9b787e61-5c06-463d-aa62-18c142735fc8	{Fisherman}	41
132ec70b-0248-450e-9ae2-38c8245dc2e9	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	99
132ec70b-0248-450e-9ae2-38c8245dc2e9	c0aaff10-a67a-4304-a3c3-875a00348870	{Soldier}	99
132ec70b-0248-450e-9ae2-38c8245dc2e9	707ffa12-afe9-4ea9-b269-5c40f47d0620	{Policeman}	99
132ec70b-0248-450e-9ae2-38c8245dc2e9	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Waiter}	99
132ec70b-0248-450e-9ae2-38c8245dc2e9	f9a23daa-fab8-418d-90f0-30a195ca171d	{Reporter}	99
132ec70b-0248-450e-9ae2-38c8245dc2e9	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Barfly,"Police Executive"}	99
132ec70b-0248-450e-9ae2-38c8245dc2e9	954bb729-459b-4676-b11b-912a33d3ca6d	{Policeman}	99
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	b41f2e59-2044-488c-b56f-8d3cfad0464c	{"Kenji Uozaki"}	1
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	41a0af3c-b4a2-443f-bdaa-7121df6fe056	{"Yuriko Shinjo"}	2
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	ba785322-fe4d-459b-b926-9fb2ed0f34ef	{"Dr. Sugimoto"}	3
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Dr. Fujimora"}	4
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	3881d7da-94c0-408b-b384-1133f2c55f46	{"Dr. Majima"}	5
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	06adecc6-cbbe-4893-a916-16e683448590	{"Officer Katsumoto"}	6
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	aa83b831-f8ba-42af-95d0-fab1c9755bbc	{"Defense Secretary"}	7
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	0b33ac7b-829f-4140-b760-74806280cf6a	{"Ichiro Shinjo"}	8
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	86209caa-4d37-4745-be23-dbee24bf244a	{"Naval Officer"}	9
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	6082d456-e1d7-43de-8174-148d1a2b09c0	{"Yutaka Wada"}	10
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	505a2aab-1965-4e16-a6b4-697e14d85d1a	{"Village Priest"}	11
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	e82833e4-7eee-4ef1-88e5-a285946593aa	{Soldier}	12
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	b08c8645-13e0-4392-b01e-3d1d069d60ae	{Horiguchi}	15
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	20f64b6e-c968-4cf2-b195-76561d8acea6	{Policeman}	16
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	2f7a44eb-826b-477e-973b-5c57a715b25a	{Soldier}	21
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	0e2de731-55a7-44be-a0b3-8213183d631e	{Soldier}	22
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{Fisherman}	23
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	5dab35d1-8242-4af3-831c-2cb48b954f61	{Soldier}	24
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	25
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	10af34fa-1751-4bfb-8950-3bd3667cc03f	{Fisherman}	27
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	b883c489-0fe7-4165-86a4-49b531a28c37	{Soldier}	33
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	c0aaff10-a67a-4304-a3c3-875a00348870	{Soldier}	34
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Soldier}	40
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	f5b35e44-efd4-4298-8124-4bccd4325e23	{Varan}	46
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	9b787e61-5c06-463d-aa62-18c142735fc8	{Varan}	47
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	f9a23daa-fab8-418d-90f0-30a195ca171d	{Reporter}	99
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	f38a2a42-a836-4c62-a1d5-265cba51076b	{"Truck Driver"}	99
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{"Bomber Pilot"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	006a5098-4f81-40eb-8f8e-785e6f43a956	{"Prince Ousu",Susano-o}	1
0a158e9d-6e48-4b6e-9674-862d952fb3ab	eac19d16-75cd-45f7-a3f3-0a033b4b5e08	{"Oto Tachibana"}	2
0a158e9d-6e48-4b6e-9674-862d952fb3ab	22c73667-bbd2-41e1-93ed-45913b29fe29	{Azami}	3
0a158e9d-6e48-4b6e-9674-862d952fb3ab	ff867685-c261-4a94-94a3-e2ec307a8616	{Kushinada}	4
0a158e9d-6e48-4b6e-9674-862d952fb3ab	f85684e5-7fc4-4c20-b88f-434069902fb7	{"Princess Miyazu"}	5
0a158e9d-6e48-4b6e-9674-862d952fb3ab	0bba81af-afab-4c75-b401-89844115a488	{"Princess Yamato"}	6
0a158e9d-6e48-4b6e-9674-862d952fb3ab	101695ef-b3a1-4aab-a52b-95f52085af37	{"Dancing Goddess"}	7
0a158e9d-6e48-4b6e-9674-862d952fb3ab	11865fca-5abe-4412-a3c3-be4e82245730	{Storyteller}	8
0a158e9d-6e48-4b6e-9674-862d952fb3ab	4ba64419-409e-4f61-bd6e-d4a651cfe3e5	{"Prince Ioki"}	9
0a158e9d-6e48-4b6e-9674-862d952fb3ab	2aec7762-810f-40b3-943c-211bc049d319	{"Prince Wakatarashi"}	10
0a158e9d-6e48-4b6e-9674-862d952fb3ab	1fa4a84a-c542-4bec-acae-dc5cfffcbd2b	{Yakumo}	14
0a158e9d-6e48-4b6e-9674-862d952fb3ab	0b33ac7b-829f-4140-b760-74806280cf6a	{"Kodate Otomo"}	15
0a158e9d-6e48-4b6e-9674-862d952fb3ab	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{Kurohiko}	16
0a158e9d-6e48-4b6e-9674-862d952fb3ab	bd14a659-bf60-4b65-9ec2-514bad9ccb72	{"Elder Kumaso"}	17
0a158e9d-6e48-4b6e-9674-862d952fb3ab	580c0f24-0d62-4891-91dd-3f0f52b834d7	{Hachihara}	18
0a158e9d-6e48-4b6e-9674-862d952fb3ab	67eeac93-8584-4ffd-a380-2ef1dbc83ee2	{Inaba}	19
0a158e9d-6e48-4b6e-9674-862d952fb3ab	b41f2e59-2044-488c-b56f-8d3cfad0464c	{"Makeri Otomo"}	20
0a158e9d-6e48-4b6e-9674-862d952fb3ab	f0cbc8fc-5aac-4278-8713-439075090442	{Deity}	26
0a158e9d-6e48-4b6e-9674-862d952fb3ab	aa83b831-f8ba-42af-95d0-fab1c9755bbc	{Okuri}	27
0a158e9d-6e48-4b6e-9674-862d952fb3ab	505a2aab-1965-4e16-a6b4-697e14d85d1a	{Anazuchi}	28
0a158e9d-6e48-4b6e-9674-862d952fb3ab	2971159a-b9d5-4858-be61-23b3e5d754fb	{"Prince Oji"}	29
0a158e9d-6e48-4b6e-9674-862d952fb3ab	86209caa-4d37-4745-be23-dbee24bf244a	{Deity}	30
0a158e9d-6e48-4b6e-9674-862d952fb3ab	3881d7da-94c0-408b-b384-1133f2c55f46	{Deity}	31
0a158e9d-6e48-4b6e-9674-862d952fb3ab	d387c2a2-4b42-48ff-bf6c-22e7909b93c8	{Deity}	32
0a158e9d-6e48-4b6e-9674-862d952fb3ab	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{"Yamato Villager"}	36
0a158e9d-6e48-4b6e-9674-862d952fb3ab	2f7a44eb-826b-477e-973b-5c57a715b25a	{"Yamato Soldier"}	39
0a158e9d-6e48-4b6e-9674-862d952fb3ab	6082d456-e1d7-43de-8174-148d1a2b09c0	{"Yamato Soldier"}	40
0a158e9d-6e48-4b6e-9674-862d952fb3ab	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{"Kumaso Soldier"}	41
0a158e9d-6e48-4b6e-9674-862d952fb3ab	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"Kumaso Soldier"}	44
0a158e9d-6e48-4b6e-9674-862d952fb3ab	9e5948a3-3002-44bf-912e-5902e5f385f1	{"Yamato Soldier"}	45
0a158e9d-6e48-4b6e-9674-862d952fb3ab	b08c8645-13e0-4392-b01e-3d1d069d60ae	{"Yamato Villager"}	46
0a158e9d-6e48-4b6e-9674-862d952fb3ab	b883c489-0fe7-4165-86a4-49b531a28c37	{"Yamato Soldier"}	54
0a158e9d-6e48-4b6e-9674-862d952fb3ab	301600d5-0f05-49a5-a23b-3f5751da8ac0	{Izanagi}	59
0a158e9d-6e48-4b6e-9674-862d952fb3ab	7890926d-3000-43b1-9be4-272609b3cca7	{Deity}	60
0a158e9d-6e48-4b6e-9674-862d952fb3ab	65a0d327-c858-475a-9648-63eb3eecd3a8	{Amatsumara}	70
0a158e9d-6e48-4b6e-9674-862d952fb3ab	b4904523-7ec4-4801-95ac-d5b65b69b168	{Futodama}	71
0a158e9d-6e48-4b6e-9674-862d952fb3ab	ff1185b5-9359-441b-8c3d-cd6ea90d67b9	{Koyane}	72
0a158e9d-6e48-4b6e-9674-862d952fb3ab	19291744-943e-4d56-a006-f82021b01e1a	{Ridouri}	73
0a158e9d-6e48-4b6e-9674-862d952fb3ab	5b57a4bc-e1db-447b-b698-812b1b6ff5e4	{"Younger Kumaso"}	77
0a158e9d-6e48-4b6e-9674-862d952fb3ab	c5411d00-f051-4771-80d5-40aa35ba7663	{Amaterasu}	78
0a158e9d-6e48-4b6e-9674-862d952fb3ab	e82833e4-7eee-4ef1-88e5-a285946593aa	{Deity,"Yamato Villager"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	56679376-b60c-4926-ae33-3c99ae021778	{"Yamato Soldier"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	415eddaf-1711-4795-9381-bc001c89b0a7	{"Utte Soldier"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	be4ac231-b431-4c18-b5a9-851e2a7713f1	{"Yamato Soldier"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	ba759075-8927-42c2-8da7-58086e6f1e27	{"Yamato Soldier"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{"Owari Villager"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	954bb729-459b-4676-b11b-912a33d3ca6d	{"Yamato Villager"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Deity}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	68f3c5f0-720d-4047-afd0-8bcdf0e89892	{"Emperor Keiko"}	11
0a158e9d-6e48-4b6e-9674-862d952fb3ab	235193ac-7eb5-4514-b03d-cefab039ed5f	{Kojikahi}	21
0a158e9d-6e48-4b6e-9674-862d952fb3ab	c0aaff10-a67a-4304-a3c3-875a00348870	{Moroto}	33
0a158e9d-6e48-4b6e-9674-862d952fb3ab	c21e21a8-e940-417c-982e-33aacb5e19a7	{"Yamato Soldier"}	47
0a158e9d-6e48-4b6e-9674-862d952fb3ab	858c1a73-ab59-4fc3-8d57-2219320bfdf7	{Omoikane}	74
0a158e9d-6e48-4b6e-9674-862d952fb3ab	f38a2a42-a836-4c62-a1d5-265cba51076b	{"Yamato Villager"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	77eed290-8834-456e-90ef-0ca75ac07973	{Otomo}	12
0a158e9d-6e48-4b6e-9674-862d952fb3ab	8dddd2f4-0d44-40b8-ab2c-b927053f99bd	{Izanami}	23
0a158e9d-6e48-4b6e-9674-862d952fb3ab	4aac5e75-0c01-418b-98fb-17d3f7138f85	{Deity}	34
0a158e9d-6e48-4b6e-9674-862d952fb3ab	0e2de731-55a7-44be-a0b3-8213183d631e	{"Yamato Villager"}	49
0a158e9d-6e48-4b6e-9674-862d952fb3ab	3254e908-84ac-4e17-a4aa-36858e3c0942	{Tamaso}	75
0a158e9d-6e48-4b6e-9674-862d952fb3ab	839d802a-34c1-4258-a75a-2a5bbfe67afc	{"Utte Villager"}	99
0a158e9d-6e48-4b6e-9674-862d952fb3ab	792be715-31b9-4b8c-8ddf-38fbea1e4101	{Takehiko}	13
0a158e9d-6e48-4b6e-9674-862d952fb3ab	7c2734fd-8980-4ca8-b562-20f07dab5641	{Tenazuchi}	25
0a158e9d-6e48-4b6e-9674-862d952fb3ab	f79f33f2-2385-49c8-9c63-e6c118835713	{"Yamato Villager"}	35
0a158e9d-6e48-4b6e-9674-862d952fb3ab	d85dc51d-4970-45b8-8b69-8472f0099fcb	{"Yamato Soldier"}	53
0a158e9d-6e48-4b6e-9674-862d952fb3ab	c71be339-7ad0-4293-8ee9-3b26258c7f7a	{Tajikarao}	76
0a158e9d-6e48-4b6e-9674-862d952fb3ab	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{"Otomo Soldier"}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	737e6959-4253-4ff2-abff-b6da339f2774	{"Major Ichiro Katsumiya"}	1
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	f30c8c01-5689-44b7-9009-468f0165763b	{"Etsuko Shiraishi"}	2
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	def945ba-826b-4d5a-b100-ce9eb2362805	{"Defense Commander"}	3
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	ba785322-fe4d-459b-b926-9fb2ed0f34ef	{"Dr. Adachi"}	4
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	f31c5c90-46a9-46c7-a071-06efd3e4955a	{"Dr. Richardson"}	5
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	fe24405b-2c4d-479e-8f0c-0233a656f259	{"Dr. Immelman"}	6
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	3c600a20-5a6b-4578-9943-3e8836dd14d3	{"Dr. Ahmed"}	7
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	18459827-37dc-45ae-b244-2ddeba4ed9e9	{Sylvia}	8
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	0b33ac7b-829f-4140-b760-74806280cf6a	{"Astronaut Kogure"}	9
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	06adecc6-cbbe-4893-a916-16e683448590	{"Astronaut Iwamura"}	10
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	6082d456-e1d7-43de-8174-148d1a2b09c0	{"Astronaut Okada"}	11
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	b41f2e59-2044-488c-b56f-8d3cfad0464c	{"Space Jet Pilot"}	12
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	3881d7da-94c0-408b-b384-1133f2c55f46	{"Detective Iriake"}	13
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	4aac5e75-0c01-418b-98fb-17d3f7138f85	{"Line Inspector"}	14
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	0e2de731-55a7-44be-a0b3-8213183d631e	{"Military Officer"}	15
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	f5b35e44-efd4-4298-8124-4bccd4325e23	{"Military Officer"}	16
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	2f7a44eb-826b-477e-973b-5c57a715b25a	{"Military Officer"}	17
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{"Military Officer"}	18
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	0887b3b0-a812-4501-8be9-2d25b4048d43	{Astronaut}	19
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	c21e21a8-e940-417c-982e-33aacb5e19a7	{"Train Conductor"}	24
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	b883c489-0fe7-4165-86a4-49b531a28c37	{Astronaut}	28
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	5dab35d1-8242-4af3-831c-2cb48b954f61	{"UN Official"}	29
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Astronaut}	31
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	18fd187f-354e-4318-b6f1-71ac2b35e169	{"Train Conductor"}	32
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	954bb729-459b-4676-b11b-912a33d3ca6d	{"Space Station Crew"}	34
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	dce8d29d-b85c-4394-80f8-5e3c910f391f	{"UN Official"}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Policeman}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	707ffa12-afe9-4ea9-b269-5c40f47d0620	{Detective}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	839d802a-34c1-4258-a75a-2a5bbfe67afc	{"UN Official"}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	c0aaff10-a67a-4304-a3c3-875a00348870	{Policeman}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	f38a2a42-a836-4c62-a1d5-265cba51076b	{"UN Official"}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Speaker}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	5e2a0e1c-5085-493e-864d-a886ffa6eb1f	{"Military Officer"}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	5240cb5f-b0a8-4c64-aa01-93a65b45d419	{Newsreader}	99
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	f9a23daa-fab8-418d-90f0-30a195ca171d	{Attendant}	99
249785ea-a53b-43e3-94d6-c5d2f2d833c4	5b57a4bc-e1db-447b-b698-812b1b6ff5e4	{Kirioka}	1
249785ea-a53b-43e3-94d6-c5d2f2d833c4	ba66d21c-9c9a-4290-848e-a89f3a2ce28d	{"Akiko Chujo"}	2
249785ea-a53b-43e3-94d6-c5d2f2d833c4	8880384d-16f9-4e12-b9c2-708c2ecaa93a	{Onishi}	3
249785ea-a53b-43e3-94d6-c5d2f2d833c4	06adecc6-cbbe-4893-a916-16e683448590	{"Detective Ozaki"}	4
249785ea-a53b-43e3-94d6-c5d2f2d833c4	99d628a5-b63c-4bf4-ae4e-1290b618f02f	{Tsudo}	5
249785ea-a53b-43e3-94d6-c5d2f2d833c4	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Detective Kobayashi"}	6
249785ea-a53b-43e3-94d6-c5d2f2d833c4	770edee6-77a7-4d9f-99f0-427750ae7aa5	{"Dr. Nikki"}	7
249785ea-a53b-43e3-94d6-c5d2f2d833c4	86209caa-4d37-4745-be23-dbee24bf244a	{Takamasa}	8
249785ea-a53b-43e3-94d6-c5d2f2d833c4	3881d7da-94c0-408b-b384-1133f2c55f46	{"Dr. Miura"}	9
249785ea-a53b-43e3-94d6-c5d2f2d833c4	4aac5e75-0c01-418b-98fb-17d3f7138f85	{"Thriller Show Announcer"}	10
249785ea-a53b-43e3-94d6-c5d2f2d833c4	bf17ae68-1ab5-48b3-93f8-12876984d814	{Taki}	11
249785ea-a53b-43e3-94d6-c5d2f2d833c4	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{Tsukamoto}	12
249785ea-a53b-43e3-94d6-c5d2f2d833c4	56679376-b60c-4926-ae33-3c99ae021778	{"Detective Marune"}	13
249785ea-a53b-43e3-94d6-c5d2f2d833c4	b08c8645-13e0-4392-b01e-3d1d069d60ae	{Reporter}	14
249785ea-a53b-43e3-94d6-c5d2f2d833c4	f79f33f2-2385-49c8-9c63-e6c118835713	{Islander}	17
249785ea-a53b-43e3-94d6-c5d2f2d833c4	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{Policeman}	18
249785ea-a53b-43e3-94d6-c5d2f2d833c4	505a2aab-1965-4e16-a6b4-697e14d85d1a	{Caretaker}	19
249785ea-a53b-43e3-94d6-c5d2f2d833c4	7890926d-3000-43b1-9be4-272609b3cca7	{Bodyguard}	20
249785ea-a53b-43e3-94d6-c5d2f2d833c4	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{Bodyguard}	21
249785ea-a53b-43e3-94d6-c5d2f2d833c4	6082d456-e1d7-43de-8174-148d1a2b09c0	{Bodyguard}	22
249785ea-a53b-43e3-94d6-c5d2f2d833c4	9e5948a3-3002-44bf-912e-5902e5f385f1	{"Police Executive"}	23
249785ea-a53b-43e3-94d6-c5d2f2d833c4	0e2de731-55a7-44be-a0b3-8213183d631e	{Tourist}	24
249785ea-a53b-43e3-94d6-c5d2f2d833c4	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Policeman}	26
249785ea-a53b-43e3-94d6-c5d2f2d833c4	885202f7-ebc0-41e6-91c8-761c1b65593a	{Waiter}	27
249785ea-a53b-43e3-94d6-c5d2f2d833c4	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{"Delivery Truck Driver"}	28
249785ea-a53b-43e3-94d6-c5d2f2d833c4	fea4a4e7-4d03-4b5b-add0-3a545a2ccb21	{"Newspaper Editor"}	29
249785ea-a53b-43e3-94d6-c5d2f2d833c4	c21e21a8-e940-417c-982e-33aacb5e19a7	{Reporter}	30
249785ea-a53b-43e3-94d6-c5d2f2d833c4	3e42b352-0c52-4e39-b028-7b5a8b45e415	{Reporter}	35
249785ea-a53b-43e3-94d6-c5d2f2d833c4	c0aaff10-a67a-4304-a3c3-875a00348870	{"Police Executive"}	40
249785ea-a53b-43e3-94d6-c5d2f2d833c4	65171b44-fd3a-4948-9613-3f7206141774	{Policeman}	42
249785ea-a53b-43e3-94d6-c5d2f2d833c4	f9a23daa-fab8-418d-90f0-30a195ca171d	{Policeman}	99
249785ea-a53b-43e3-94d6-c5d2f2d833c4	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{"Thriller Show Employee"}	99
249785ea-a53b-43e3-94d6-c5d2f2d833c4	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Reporter}	99
249785ea-a53b-43e3-94d6-c5d2f2d833c4	954bb729-459b-4676-b11b-912a33d3ca6d	{Policeman}	99
249785ea-a53b-43e3-94d6-c5d2f2d833c4	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Waiter}	99
249785ea-a53b-43e3-94d6-c5d2f2d833c4	e82833e4-7eee-4ef1-88e5-a285946593aa	{"Police Executive"}	99
249785ea-a53b-43e3-94d6-c5d2f2d833c4	be4ac231-b431-4c18-b5a9-851e2a7713f1	{"Crime Scene Investigator"}	99
249785ea-a53b-43e3-94d6-c5d2f2d833c4	ba759075-8927-42c2-8da7-58086e6f1e27	{Policeman}	99
e8ccb201-e076-48cb-9307-f8b99101f133	27bfdcc6-5f02-47fd-ae38-7ea8d9fac219	{"Detective Okamoto"}	1
e8ccb201-e076-48cb-9307-f8b99101f133	efaedbdc-65d4-4bdd-904c-3eb10cfe25d9	{"Fujichiyo Kasuga"}	2
e8ccb201-e076-48cb-9307-f8b99101f133	06adecc6-cbbe-4893-a916-16e683448590	{Mizuno}	3
e8ccb201-e076-48cb-9307-f8b99101f133	db1ce840-a3bc-4f58-8caf-5d2bcf272892	{"Kyoko Kono"}	4
e8ccb201-e076-48cb-9307-f8b99101f133	0b33ac7b-829f-4140-b760-74806280cf6a	{"Dr. Tamiya"}	5
e8ccb201-e076-48cb-9307-f8b99101f133	86209caa-4d37-4745-be23-dbee24bf244a	{"Detective Tabata"}	6
e8ccb201-e076-48cb-9307-f8b99101f133	67eeac93-8584-4ffd-a380-2ef1dbc83ee2	{"Detective Inao"}	7
e8ccb201-e076-48cb-9307-f8b99101f133	3881d7da-94c0-408b-b384-1133f2c55f46	{"Dr. Sano"}	8
e8ccb201-e076-48cb-9307-f8b99101f133	f0cbc8fc-5aac-4278-8713-439075090442	{"Jiya (Kasuga's Manservant)"}	9
e8ccb201-e076-48cb-9307-f8b99101f133	770edee6-77a7-4d9f-99f0-427750ae7aa5	{"Police Executive"}	10
e8ccb201-e076-48cb-9307-f8b99101f133	aa83b831-f8ba-42af-95d0-fab1c9755bbc	{"Newspaper Executive"}	11
e8ccb201-e076-48cb-9307-f8b99101f133	fea4a4e7-4d03-4b5b-add0-3a545a2ccb21	{"Newspaper Editor"}	12
e8ccb201-e076-48cb-9307-f8b99101f133	7f06db03-42ca-4a84-bb01-a856eb036026	{"Bank Official"}	13
e8ccb201-e076-48cb-9307-f8b99101f133	1fa4a84a-c542-4bec-acae-dc5cfffcbd2b	{"Detective Fujita"}	14
e8ccb201-e076-48cb-9307-f8b99101f133	b41f2e59-2044-488c-b56f-8d3cfad0464c	{"Reporter Kawasaki"}	15
e8ccb201-e076-48cb-9307-f8b99101f133	56679376-b60c-4926-ae33-3c99ae021778	{Nishiyama}	16
e8ccb201-e076-48cb-9307-f8b99101f133	478bc636-02cd-42e9-901c-a3acb24df07e	{"Kasuga's Instructor"}	17
e8ccb201-e076-48cb-9307-f8b99101f133	c21e21a8-e940-417c-982e-33aacb5e19a7	{Policeman}	18
e8ccb201-e076-48cb-9307-f8b99101f133	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"Jail Officer"}	20
e8ccb201-e076-48cb-9307-f8b99101f133	040d7f31-5c23-49df-9b69-d3fb78b6d93f	{"Newspaper Executive"}	21
e8ccb201-e076-48cb-9307-f8b99101f133	f9094a20-8286-4b66-bd41-eafd905c9d83	{"Instructor's Wife"}	22
e8ccb201-e076-48cb-9307-f8b99101f133	0e2de731-55a7-44be-a0b3-8213183d631e	{"Newspaper Executive"}	23
e8ccb201-e076-48cb-9307-f8b99101f133	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{"Detective Osaki"}	24
e8ccb201-e076-48cb-9307-f8b99101f133	b883c489-0fe7-4165-86a4-49b531a28c37	{Policeman}	25
e8ccb201-e076-48cb-9307-f8b99101f133	f38a2a42-a836-4c62-a1d5-265cba51076b	{"Jail Officer"}	26
e8ccb201-e076-48cb-9307-f8b99101f133	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{"Man in Audience"}	27
e8ccb201-e076-48cb-9307-f8b99101f133	5dab35d1-8242-4af3-831c-2cb48b954f61	{"Police Executive"}	28
e8ccb201-e076-48cb-9307-f8b99101f133	954bb729-459b-4676-b11b-912a33d3ca6d	{"Detective Hotta"}	29
e8ccb201-e076-48cb-9307-f8b99101f133	e82833e4-7eee-4ef1-88e5-a285946593aa	{"Police Executive"}	30
e8ccb201-e076-48cb-9307-f8b99101f133	65171b44-fd3a-4948-9613-3f7206141774	{Banker}	34
e8ccb201-e076-48cb-9307-f8b99101f133	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Reporter}	35
e8ccb201-e076-48cb-9307-f8b99101f133	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Reporter}	38
e8ccb201-e076-48cb-9307-f8b99101f133	b3d271ee-f159-45dd-b774-cc823c21d82d	{Reporter}	39
e8ccb201-e076-48cb-9307-f8b99101f133	f9a23daa-fab8-418d-90f0-30a195ca171d	{Reporter}	99
e8ccb201-e076-48cb-9307-f8b99101f133	ba759075-8927-42c2-8da7-58086e6f1e27	{Scientist}	99
e8ccb201-e076-48cb-9307-f8b99101f133	839d802a-34c1-4258-a75a-2a5bbfe67afc	{"Bank Official"}	99
e8ccb201-e076-48cb-9307-f8b99101f133	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{Reporter}	99
e8ccb201-e076-48cb-9307-f8b99101f133	707ffa12-afe9-4ea9-b269-5c40f47d0620	{Policeman}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	16cf1b1e-dfd0-420d-a624-325b6287dd1a	{"Mokichi Tamura"}	1
9b724e83-39e6-4e57-b112-81e74d578ae0	2aec7762-810f-40b3-943c-211bc049d319	{Takano}	2
9b724e83-39e6-4e57-b112-81e74d578ae0	63df9c5e-35b7-4e72-9e6f-4bb8216f7842	{"Saeko Tamura"}	3
9b724e83-39e6-4e57-b112-81e74d578ae0	101695ef-b3a1-4aab-a52b-95f52085af37	{"Yoshi Tamura"}	4
9b724e83-39e6-4e57-b112-81e74d578ae0	ba66d21c-9c9a-4290-848e-a89f3a2ce28d	{"Sanae Ebara"}	5
9b724e83-39e6-4e57-b112-81e74d578ae0	e18af03d-2ca1-4c1d-9689-761a12ded64f	{Ebara}	6
9b724e83-39e6-4e57-b112-81e74d578ae0	4d4125bc-22de-4f64-9844-720cd84d9a14	{Watkins}	7
9b724e83-39e6-4e57-b112-81e74d578ae0	77eed290-8834-456e-90ef-0ca75ac07973	{"Takano's Captain"}	8
9b724e83-39e6-4e57-b112-81e74d578ae0	15b76bdf-bf34-413c-8726-cc8c54c87b9a	{"Prime Minister"}	9
9b724e83-39e6-4e57-b112-81e74d578ae0	6eeae332-74cd-43e3-a747-e0ab5d6d1f66	{Minister}	10
9b724e83-39e6-4e57-b112-81e74d578ae0	8880384d-16f9-4e12-b9c2-708c2ecaa93a	{Minister}	11
9b724e83-39e6-4e57-b112-81e74d578ae0	c0eeeca2-2862-4a6f-bf5b-66920a8172a8	{"Cabinet Secretary"}	12
9b724e83-39e6-4e57-b112-81e74d578ae0	7c2734fd-8980-4ca8-b562-20f07dab5641	{Ohara}	13
9b724e83-39e6-4e57-b112-81e74d578ae0	def945ba-826b-4d5a-b100-ce9eb2362805	{"Missile Defense Officer"}	14
9b724e83-39e6-4e57-b112-81e74d578ae0	6de27671-6ff7-4603-beb5-1d683c42c4c2	{"Press Club Chauffeur"}	15
9b724e83-39e6-4e57-b112-81e74d578ae0	b41f2e59-2044-488c-b56f-8d3cfad0464c	{"Tamura's Stock Broker"}	17
9b724e83-39e6-4e57-b112-81e74d578ae0	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{Reporter}	19
9b724e83-39e6-4e57-b112-81e74d578ae0	6082d456-e1d7-43de-8174-148d1a2b09c0	{"Missile Defense Officer"}	20
9b724e83-39e6-4e57-b112-81e74d578ae0	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{"Defense Officer"}	21
9b724e83-39e6-4e57-b112-81e74d578ae0	0e2de731-55a7-44be-a0b3-8213183d631e	{Minister}	26
9b724e83-39e6-4e57-b112-81e74d578ae0	20f64b6e-c968-4cf2-b195-76561d8acea6	{Minister}	27
9b724e83-39e6-4e57-b112-81e74d578ae0	9e5948a3-3002-44bf-912e-5902e5f385f1	{Minister}	28
9b724e83-39e6-4e57-b112-81e74d578ae0	415eddaf-1711-4795-9381-bc001c89b0a7	{"Helicopter Crew"}	30
9b724e83-39e6-4e57-b112-81e74d578ae0	b3d271ee-f159-45dd-b774-cc823c21d82d	{Sailor}	31
9b724e83-39e6-4e57-b112-81e74d578ae0	f9a23daa-fab8-418d-90f0-30a195ca171d	{Reporter}	32
9b724e83-39e6-4e57-b112-81e74d578ae0	10af34fa-1751-4bfb-8950-3bd3667cc03f	{"Defense Crew"}	33
9b724e83-39e6-4e57-b112-81e74d578ae0	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{"Defense Crew"}	34
9b724e83-39e6-4e57-b112-81e74d578ae0	fe24405b-2c4d-479e-8f0c-0233a656f259	{"Federation Missile Commander"}	52
9b724e83-39e6-4e57-b112-81e74d578ae0	0887b3b0-a812-4501-8be9-2d25b4048d43	{"Alliance Pilot"}	53
9b724e83-39e6-4e57-b112-81e74d578ae0	f02a3856-95fc-4e5b-8d58-9f733e3b2278	{"TV Singer"}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	5e2a0e1c-5085-493e-864d-a886ffa6eb1f	{"Alliance Officer"}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	5240cb5f-b0a8-4c64-aa01-93a65b45d419	{"TV Announcer"}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	eb909bc3-8688-4b5d-91c7-bae649a84c2a	{"TV Singer"}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	ba759075-8927-42c2-8da7-58086e6f1e27	{"TV Singer"}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{"Press Club Chauffeur"}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Official}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	65171b44-fd3a-4948-9613-3f7206141774	{Sailor}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Reporter,"Security Guard"}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	e82833e4-7eee-4ef1-88e5-a285946593aa	{"Press Club Chauffeur"}	99
9b724e83-39e6-4e57-b112-81e74d578ae0	707ffa12-afe9-4ea9-b269-5c40f47d0620	{"Defense Officer"}	99
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	16cf1b1e-dfd0-420d-a624-325b6287dd1a	{"Senichiro Fukuda"}	1
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	34de1ef2-9428-4c7e-8512-5683f7cced38	{"Dr. Shinichi Chujo"}	2
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	f85684e5-7fc4-4c20-b88f-434069902fb7	{"Michi Hanamura"}	3
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	4d4125bc-22de-4f64-9844-720cd84d9a14	{"Clark Nelson"}	5
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	6eeae332-74cd-43e3-a747-e0ab5d6d1f66	{"Dr. Harada"}	6
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	792be715-31b9-4b8c-8ddf-38fbea1e4101	{Doctor}	7
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Helicopter Pilot"}	8
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	8880384d-16f9-4e12-b9c2-708c2ecaa93a	{General}	9
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	bd14a659-bf60-4b65-9ec2-514bad9ccb72	{"Newspaper Editor"}	10
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	67eeac93-8584-4ffd-a380-2ef1dbc83ee2	{"Ship's Captain"}	11
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	86209caa-4d37-4745-be23-dbee24bf244a	{Soldier}	12
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	56679376-b60c-4926-ae33-3c99ae021778	{"Marooned Sailor"}	13
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	d9b9fe70-61d5-477e-b927-453ab57591c9	{"Marooned Sailor"}	14
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	040d7f31-5c23-49df-9b69-d3fb78b6d93f	{"Nelson's Henchman"}	16
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"Dam Worker"}	17
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	c21e21a8-e940-417c-982e-33aacb5e19a7	{"Expedition Member"}	20
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	2f7a44eb-826b-477e-973b-5c57a715b25a	{"Cruise Ship Captain"}	23
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{"Expedition Member"}	26
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	9d5454d0-b6de-4b62-bf4e-da467bd6c53b	{"Nelson's Henchman"}	27
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	0887b3b0-a812-4501-8be9-2d25b4048d43	{"Nelson's Henchman"}	29
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	5e2a0e1c-5085-493e-864d-a886ffa6eb1f	{"Rolisican Mayor"}	30
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	fe24405b-2c4d-479e-8f0c-0233a656f259	{"Rolisican Ambassador"}	31
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	7b5238d1-ec51-47fa-ae20-8f15e501944f	{"Rolisican Policeman"}	32
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{Policeman}	34
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	b3d271ee-f159-45dd-b774-cc823c21d82d	{"Coast Guard"}	35
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	f5b35e44-efd4-4298-8124-4bccd4325e23	{Mothra}	39
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	42
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	839d802a-34c1-4258-a75a-2a5bbfe67afc	{"Military Officer"}	43
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	18fd187f-354e-4318-b6f1-71ac2b35e169	{"Dam Worker"}	44
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	b883c489-0fe7-4165-86a4-49b531a28c37	{"Fighter Pilot"}	45
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Pilot}	46
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	f9a23daa-fab8-418d-90f0-30a195ca171d	{"Expedition Member"}	50
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	e82833e4-7eee-4ef1-88e5-a285946593aa	{Soldier}	52
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	9b787e61-5c06-463d-aa62-18c142735fc8	{Mothra}	53
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{Evacuee}	56
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	f02a3856-95fc-4e5b-8d58-9f733e3b2278	{"Cruise Liner Helmsman"}	59
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Reporter}	61
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Policeman}	99
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{Soldier}	99
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	f38a2a42-a836-4c62-a1d5-265cba51076b	{Doctor}	99
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	eb909bc3-8688-4b5d-91c7-bae649a84c2a	{Policeman}	99
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Soldier}	99
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	5240cb5f-b0a8-4c64-aa01-93a65b45d419	{Announcer}	99
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	954bb729-459b-4676-b11b-912a33d3ca6d	{"Dam Worker"}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	737e6959-4253-4ff2-abff-b6da339f2774	{"Dr. Tazawa"}	1
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	ba66d21c-9c9a-4290-848e-a89f3a2ce28d	{"Tomoko Sonoda"}	2
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	4ba64419-409e-4f61-bd6e-d4a651cfe3e5	{"Tatsuma Kanai"}	3
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	22c73667-bbd2-41e1-93ed-45913b29fe29	{"Takiko Nomura"}	4
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	6ec04ee3-d9f9-4d8b-91e2-ab10ae2e9d48	{"Astronaut Wakabayashi"}	5
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Captain Endo"}	6
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Lt. Saiki"}	7
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"Captain Raizo Sonoda"}	8
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	6eeae332-74cd-43e3-a747-e0ab5d6d1f66	{"Dr. Kono"}	9
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	bd14a659-bf60-4b65-9ec2-514bad9ccb72	{"Dr. Keisuke Sonoda"}	10
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	8880384d-16f9-4e12-b9c2-708c2ecaa93a	{"Minister Tada"}	11
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	1fa4a84a-c542-4bec-acae-dc5cfffcbd2b	{"South Pole Engineer Sanada"}	12
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	bf17ae68-1ab5-48b3-93f8-12876984d814	{Doctor}	13
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	770edee6-77a7-4d9f-99f0-427750ae7aa5	{"Prime Minister Seki"}	14
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	f0248816-9020-47ff-a5f2-b77c0e43002c	{"Minister Murata"}	15
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	bdd9d156-3b37-4094-b65a-162ce892674d	{"Minister Kinami"}	16
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	eb909bc3-8688-4b5d-91c7-bae649a84c2a	{"Astronaut Ito"}	17
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	b41f2e59-2044-488c-b56f-8d3cfad0464c	{"Satellite Commander"}	18
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	db1ce840-a3bc-4f58-8caf-5d2bcf272892	{Secretary}	19
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	7890926d-3000-43b1-9be4-272609b3cca7	{Barfly}	20
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	ecb241cd-e5e8-4239-a084-3fc522475618	{"UN Ambassador"}	21
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	1e17ee46-4e58-4e9a-bf1b-5487910aae4e	{Gibson}	22
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	c0aaff10-a67a-4304-a3c3-875a00348870	{"Security Guard"}	23
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	6082d456-e1d7-43de-8174-148d1a2b09c0	{"Lt. Manabe"}	24
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	155ce21a-83a4-4059-bf88-08cf6d988842	{"Hayao Sonoda"}	25
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	4aac5e75-0c01-418b-98fb-17d3f7138f85	{"Taxi Driver"}	26
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	b883c489-0fe7-4165-86a4-49b531a28c37	{"Spaceship Crew"}	29
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{"Spaceship Crew"}	33
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{Reporter}	34
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	954bb729-459b-4676-b11b-912a33d3ca6d	{"Spaceship Crew"}	35
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	3b4d8cf3-372d-4180-a625-d7ece05d7d58	{"Spaceship Crew"}	36
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	e82833e4-7eee-4ef1-88e5-a285946593aa	{Minister}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	3e42b352-0c52-4e39-b028-7b5a8b45e415	{"Spaceship Crew"}	37
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	5dab35d1-8242-4af3-831c-2cb48b954f61	{Minister}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	f5b35e44-efd4-4298-8124-4bccd4325e23	{Magma}	38
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	f38a2a42-a836-4c62-a1d5-265cba51076b	{Minister}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	b3d271ee-f159-45dd-b774-cc823c21d82d	{"Spaceship Crew"}	42
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	5e2a0e1c-5085-493e-864d-a886ffa6eb1f	{"UN Ambassador"}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	45
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	ba759075-8927-42c2-8da7-58086e6f1e27	{"Satellite Crew"}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	0e2de731-55a7-44be-a0b3-8213183d631e	{Minister}	50
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	5240cb5f-b0a8-4c64-aa01-93a65b45d419	{"TV Announcer"}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	f9a23daa-fab8-418d-90f0-30a195ca171d	{Reporter,"Satellite Crew"}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	0887b3b0-a812-4501-8be9-2d25b4048d43	{"South Pole Crew"}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	478bc636-02cd-42e9-901c-a3acb24df07e	{Minister}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{"South Pole Crew"}	99
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{Minister}	99
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	ff76604e-909d-489b-8c32-64de3d04a0fc	{"Osamu Sakurai"}	1
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Kazuo Fujita"}	2
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	235193ac-7eb5-4514-b03d-cefab039ed5f	{"Kinsaburo Furue"}	3
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	19291744-943e-4d56-a006-f82021b01e1a	{"Mr. Tako"}	4
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"General Shinzo"}	5
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Minister Shigezawa"}	6
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	ca42052c-b7db-4e90-a825-bf0afe11a5b9	{"Fumiko Sakurai"}	7
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	d08d501c-fb18-4360-8e59-9685b5ecead3	{Tamiye}	8
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	67eeac93-8584-4ffd-a380-2ef1dbc83ee2	{"Faro Island Chief"}	10
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	86209caa-4d37-4745-be23-dbee24bf244a	{"Research Ship Captain"}	11
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	4aac5e75-0c01-418b-98fb-17d3f7138f85	{"Island Priest"}	12
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	478bc636-02cd-42e9-901c-a3acb24df07e	{"Dr. Onuki"}	13
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	1fa4a84a-c542-4bec-acae-dc5cfffcbd2b	{"Coast Guard"}	14
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	bf17ae68-1ab5-48b3-93f8-12876984d814	{Obayashi}	15
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	fea4a4e7-4d03-4b5b-add0-3a545a2ccb21	{"Dr. Makino"}	16
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	f79f33f2-2385-49c8-9c63-e6c118835713	{Guide}	17
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	56679376-b60c-4926-ae33-3c99ae021778	{Soldier}	18
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	d9b9fe70-61d5-477e-b927-453ab57591c9	{"Obayashi's Assistant"}	19
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{"Transport Ship Captain"}	20
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	6082d456-e1d7-43de-8174-148d1a2b09c0	{Soldier}	21
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	c21e21a8-e940-417c-982e-33aacb5e19a7	{Soldier}	22
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	885202f7-ebc0-41e6-91c8-761c1b65593a	{Sailor}	23
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	415eddaf-1711-4795-9381-bc001c89b0a7	{Reporter}	25
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	2f7a44eb-826b-477e-973b-5c57a715b25a	{"Military Official"}	26
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	060bffd0-c2bc-4a01-8928-e4921c6ea447	{"TV Host"}	28
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	0e2de731-55a7-44be-a0b3-8213183d631e	{"Military Official"}	29
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	9e5948a3-3002-44bf-912e-5902e5f385f1	{Evacuee}	30
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	0a4287a6-254e-42ce-b2fa-1a403c80947b	{Bystander}	32
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	33
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Reporter}	34
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Soldier}	35
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	d559ba92-0eba-4724-b9f3-08371868d9db	{"Submarine Captain"}	41
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	fe24405b-2c4d-479e-8f0c-0233a656f259	{Scientist}	42
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	0887b3b0-a812-4501-8be9-2d25b4048d43	{Scientist}	43
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"King Kong"}	44
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	9b787e61-5c06-463d-aa62-18c142735fc8	{Godzilla}	45
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	f5b35e44-efd4-4298-8124-4bccd4325e23	{Godzilla}	46
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	5dab35d1-8242-4af3-831c-2cb48b954f61	{"Military Official"}	99
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	b883c489-0fe7-4165-86a4-49b531a28c37	{Soldier}	99
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Soldier}	99
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	954bb729-459b-4676-b11b-912a33d3ca6d	{"Helicopter Pilot"}	99
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	707ffa12-afe9-4ea9-b269-5c40f47d0620	{Sailor}	99
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	e82833e4-7eee-4ef1-88e5-a285946593aa	{"Military Official"}	99
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Scientist}	99
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{Islander}	99
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	4ba64419-409e-4f61-bd6e-d4a651cfe3e5	{"Kenji Murai"}	1
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	22c73667-bbd2-41e1-93ed-45913b29fe29	{"Mami Sekiguchi"}	2
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	34de1ef2-9428-4c7e-8512-5683f7cced38	{"Naoyuki Sakuta"}	3
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Senzo Koyama"}	4
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	6ec04ee3-d9f9-4d8b-91e2-ab10ae2e9d48	{"Etsuro Yoshida"}	5
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	06adecc6-cbbe-4893-a916-16e683448590	{"Masafumi Kasai"}	6
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	f58f875c-2183-462f-9ef9-d34c20bd5748	{"Akiko Soma"}	7
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	7890926d-3000-43b1-9be4-272609b3cca7	{"Mushroom Man"}	8
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	0e2de731-55a7-44be-a0b3-8213183d631e	{Doctor}	9
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	e82833e4-7eee-4ef1-88e5-a285946593aa	{Official}	10
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Doctor}	11
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	5dab35d1-8242-4af3-831c-2cb48b954f61	{Doctor}	12
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Official}	13
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	f5b35e44-efd4-4298-8124-4bccd4325e23	{Official}	14
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	9b787e61-5c06-463d-aa62-18c142735fc8	{"Mushroom Man"}	15
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	10af34fa-1751-4bfb-8950-3bd3667cc03f	{"Mushroom Man"}	18
b30c5657-a980-489b-bd91-d58e63609102	006a5098-4f81-40eb-8f8e-785e6f43a956	{Sukeza}	1
b30c5657-a980-489b-bd91-d58e63609102	7e735ef6-b865-424d-9291-0387716327cb	{"The Black Pirate"}	2
b30c5657-a980-489b-bd91-d58e63609102	19291744-943e-4d56-a006-f82021b01e1a	{"The Wizard of Kume"}	3
b30c5657-a980-489b-bd91-d58e63609102	2ffd8877-261d-408c-97df-97bd6eb5748d	{Sobei}	4
b30c5657-a980-489b-bd91-d58e63609102	ca42052c-b7db-4e90-a825-bf0afe11a5b9	{"Princess Yaya"}	5
b30c5657-a980-489b-bd91-d58e63609102	d08d501c-fb18-4360-8e59-9685b5ecead3	{"Yaya's Handmaiden"}	6
b30c5657-a980-489b-bd91-d58e63609102	22c73667-bbd2-41e1-93ed-45913b29fe29	{"Miwa, the Rebel Leader"}	7
b30c5657-a980-489b-bd91-d58e63609102	99d628a5-b63c-4bf4-ae4e-1290b618f02f	{"The Chancellor"}	8
b30c5657-a980-489b-bd91-d58e63609102	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{Slim}	9
b30c5657-a980-489b-bd91-d58e63609102	37f86cbf-f363-4661-a911-94a2505f0da0	{"The Prince of Ming"}	10
b30c5657-a980-489b-bd91-d58e63609102	7890926d-3000-43b1-9be4-272609b3cca7	{"Granny the Witch"}	11
b30c5657-a980-489b-bd91-d58e63609102	bd14a659-bf60-4b65-9ec2-514bad9ccb72	{"King Rasetsu"}	12
b30c5657-a980-489b-bd91-d58e63609102	a860b944-2633-47f3-bea6-8f6a2dece2ff	{"Mustachioed Rebel"}	13
b30c5657-a980-489b-bd91-d58e63609102	eb909bc3-8688-4b5d-91c7-bae649a84c2a	{"Tall Rebel"}	14
b30c5657-a980-489b-bd91-d58e63609102	32b3608c-6052-4ea4-9f14-38fa182a0340	{"Turbaned Rebel"}	15
b30c5657-a980-489b-bd91-d58e63609102	707ffa12-afe9-4ea9-b269-5c40f47d0620	{Samurai}	27
b30c5657-a980-489b-bd91-d58e63609102	885202f7-ebc0-41e6-91c8-761c1b65593a	{"Samurai Ichizo"}	16
b30c5657-a980-489b-bd91-d58e63609102	2ebd5427-97aa-4b77-b5af-66a55ff46fc4	{"Prison Guard"}	99
b30c5657-a980-489b-bd91-d58e63609102	67eeac93-8584-4ffd-a380-2ef1dbc83ee2	{"Ming Advisor"}	17
b30c5657-a980-489b-bd91-d58e63609102	e82833e4-7eee-4ef1-88e5-a285946593aa	{Villager}	99
b30c5657-a980-489b-bd91-d58e63609102	113749dd-9700-4434-b8d7-4c55a7f00aa7	{"Samurai Tokubei"}	18
b30c5657-a980-489b-bd91-d58e63609102	f38a2a42-a836-4c62-a1d5-265cba51076b	{Villager}	99
b30c5657-a980-489b-bd91-d58e63609102	040d7f31-5c23-49df-9b69-d3fb78b6d93f	{Archer}	19
b30c5657-a980-489b-bd91-d58e63609102	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Pirate}	99
b30c5657-a980-489b-bd91-d58e63609102	6082d456-e1d7-43de-8174-148d1a2b09c0	{Samurai}	20
b30c5657-a980-489b-bd91-d58e63609102	c0aaff10-a67a-4304-a3c3-875a00348870	{"Jail Keeper"}	22
b30c5657-a980-489b-bd91-d58e63609102	c21e21a8-e940-417c-982e-33aacb5e19a7	{Samurai}	23
b30c5657-a980-489b-bd91-d58e63609102	fd1d5a32-95c6-45da-8b27-99e6f9b8b9af	{"Palace Guard"}	25
b30c5657-a980-489b-bd91-d58e63609102	e5f1bba1-e4e2-452b-bb62-1747d34ca1e1	{"Giant Bodyguard"}	26
5df297a2-5f6d-430d-b7fc-952e97ac9d79	ff76604e-909d-489b-8c32-64de3d04a0fc	{"Susumu Hatanaka"}	1
5df297a2-5f6d-430d-b7fc-952e97ac9d79	975efb7b-e01c-4ca2-9c8d-6deaddcf6ade	{"Makoto Jinguji"}	2
5df297a2-5f6d-430d-b7fc-952e97ac9d79	235193ac-7eb5-4514-b03d-cefab039ed5f	{"Yoshito Nishibe"}	3
5df297a2-5f6d-430d-b7fc-952e97ac9d79	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{Unno}	4
5df297a2-5f6d-430d-b7fc-952e97ac9d79	6eeae332-74cd-43e3-a747-e0ab5d6d1f66	{"Admiral Kusumi"}	5
5df297a2-5f6d-430d-b7fc-952e97ac9d79	34de1ef2-9428-4c7e-8512-5683f7cced38	{"Detective Ito"}	6
5df297a2-5f6d-430d-b7fc-952e97ac9d79	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"Captain Hachiro Jinguji"}	7
5df297a2-5f6d-430d-b7fc-952e97ac9d79	86209caa-4d37-4745-be23-dbee24bf244a	{"Lt. Amano"}	8
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Reporter}	24
5df297a2-5f6d-430d-b7fc-952e97ac9d79	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Mu Agent No. 23"}	9
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	d08d501c-fb18-4360-8e59-9685b5ecead3	{Hamako}	4
5df297a2-5f6d-430d-b7fc-952e97ac9d79	7890926d-3000-43b1-9be4-272609b3cca7	{"High Priest of Mu"}	10
5df297a2-5f6d-430d-b7fc-952e97ac9d79	b86678a4-b0f5-477d-af53-af0dde7e60ef	{General}	11
5df297a2-5f6d-430d-b7fc-952e97ac9d79	def945ba-826b-4d5a-b100-ce9eb2362805	{"Military Officer"}	12
5df297a2-5f6d-430d-b7fc-952e97ac9d79	0b33ac7b-829f-4140-b760-74806280cf6a	{"Kidnapped Scientist"}	13
5df297a2-5f6d-430d-b7fc-952e97ac9d79	4aac5e75-0c01-418b-98fb-17d3f7138f85	{"Taxi Driver"}	14
5df297a2-5f6d-430d-b7fc-952e97ac9d79	609b8ee2-5b44-481b-82e9-5fafb7403036	{"Empress of Mu"}	15
5df297a2-5f6d-430d-b7fc-952e97ac9d79	fd1d5a32-95c6-45da-8b27-99e6f9b8b9af	{"Atragon Crew"}	16
5df297a2-5f6d-430d-b7fc-952e97ac9d79	6082d456-e1d7-43de-8174-148d1a2b09c0	{"Kidnapped Scientist"}	17
5df297a2-5f6d-430d-b7fc-952e97ac9d79	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{"Military Officer"}	18
5df297a2-5f6d-430d-b7fc-952e97ac9d79	d85dc51d-4970-45b8-8b69-8472f0099fcb	{"Atragon Crew"}	19
5df297a2-5f6d-430d-b7fc-952e97ac9d79	040d7f31-5c23-49df-9b69-d3fb78b6d93f	{"Cargo Ship Captain"}	20
5df297a2-5f6d-430d-b7fc-952e97ac9d79	885202f7-ebc0-41e6-91c8-761c1b65593a	{"Cargo Ship Crew"}	21
5df297a2-5f6d-430d-b7fc-952e97ac9d79	2f7a44eb-826b-477e-973b-5c57a715b25a	{"Military Officer"}	22
5df297a2-5f6d-430d-b7fc-952e97ac9d79	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{Policeman}	23
5df297a2-5f6d-430d-b7fc-952e97ac9d79	b883c489-0fe7-4165-86a4-49b531a28c37	{"Military Officer"}	25
5df297a2-5f6d-430d-b7fc-952e97ac9d79	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{"Mihara Tourist"}	27
5df297a2-5f6d-430d-b7fc-952e97ac9d79	954bb729-459b-4676-b11b-912a33d3ca6d	{"Mihara Tourist"}	28
5df297a2-5f6d-430d-b7fc-952e97ac9d79	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"Mu Citizen"}	29
5df297a2-5f6d-430d-b7fc-952e97ac9d79	f5b35e44-efd4-4298-8124-4bccd4325e23	{"Military Officer"}	30
5df297a2-5f6d-430d-b7fc-952e97ac9d79	0e2de731-55a7-44be-a0b3-8213183d631e	{"Military Officer"}	31
5df297a2-5f6d-430d-b7fc-952e97ac9d79	9e5948a3-3002-44bf-912e-5902e5f385f1	{"Atragon Crew"}	33
5df297a2-5f6d-430d-b7fc-952e97ac9d79	b3d271ee-f159-45dd-b774-cc823c21d82d	{Soldier}	34
5df297a2-5f6d-430d-b7fc-952e97ac9d79	65171b44-fd3a-4948-9613-3f7206141774	{Soldier}	38
5df297a2-5f6d-430d-b7fc-952e97ac9d79	5dab35d1-8242-4af3-831c-2cb48b954f61	{"Military Officer"}	39
5df297a2-5f6d-430d-b7fc-952e97ac9d79	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Soldier}	99
5df297a2-5f6d-430d-b7fc-952e97ac9d79	f9a23daa-fab8-418d-90f0-30a195ca171d	{"Atragon Crew"}	99
5df297a2-5f6d-430d-b7fc-952e97ac9d79	707ffa12-afe9-4ea9-b269-5c40f47d0620	{"Atragon Crew"}	99
5df297a2-5f6d-430d-b7fc-952e97ac9d79	0887b3b0-a812-4501-8be9-2d25b4048d43	{"Mu Soldier"}	99
75bb901c-e41c-494f-aae8-7a5282f3bf96	2aec7762-810f-40b3-943c-211bc049d319	{"Ichiro Sakai"}	1
75bb901c-e41c-494f-aae8-7a5282f3bf96	63df9c5e-35b7-4e72-9e6f-4bb8216f7842	{"Junko Nakanishi"}	2
75bb901c-e41c-494f-aae8-7a5282f3bf96	34de1ef2-9428-4c7e-8512-5683f7cced38	{"Dr. Miura"}	3
75bb901c-e41c-494f-aae8-7a5282f3bf96	235193ac-7eb5-4514-b03d-cefab039ed5f	{"Jiro Nakamura"}	4
75bb901c-e41c-494f-aae8-7a5282f3bf96	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{Torahata}	5
75bb901c-e41c-494f-aae8-7a5282f3bf96	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"Newspaper Editor"}	7
75bb901c-e41c-494f-aae8-7a5282f3bf96	86209caa-4d37-4745-be23-dbee24bf244a	{Kumayama}	8
75bb901c-e41c-494f-aae8-7a5282f3bf96	060bffd0-c2bc-4a01-8928-e4921c6ea447	{"Industrial Park Developer"}	9
75bb901c-e41c-494f-aae8-7a5282f3bf96	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{"School Principal"}	10
75bb901c-e41c-494f-aae8-7a5282f3bf96	d387c2a2-4b42-48ff-bf6c-22e7909b93c8	{"Chief Fisherman"}	11
75bb901c-e41c-494f-aae8-7a5282f3bf96	b86678a4-b0f5-477d-af53-af0dde7e60ef	{General}	12
75bb901c-e41c-494f-aae8-7a5282f3bf96	4aac5e75-0c01-418b-98fb-17d3f7138f85	{"Village Priest"}	13
75bb901c-e41c-494f-aae8-7a5282f3bf96	56679376-b60c-4926-ae33-3c99ae021778	{Sailor}	14
75bb901c-e41c-494f-aae8-7a5282f3bf96	b41f2e59-2044-488c-b56f-8d3cfad0464c	{Soldier}	15
75bb901c-e41c-494f-aae8-7a5282f3bf96	c21e21a8-e940-417c-982e-33aacb5e19a7	{"Village Policeman"}	16
75bb901c-e41c-494f-aae8-7a5282f3bf96	2f7a44eb-826b-477e-973b-5c57a715b25a	{Soldier}	17
75bb901c-e41c-494f-aae8-7a5282f3bf96	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{Policeman}	18
75bb901c-e41c-494f-aae8-7a5282f3bf96	f79f33f2-2385-49c8-9c63-e6c118835713	{Fisherman}	19
75bb901c-e41c-494f-aae8-7a5282f3bf96	67eeac93-8584-4ffd-a380-2ef1dbc83ee2	{"Infant Island Chief"}	20
75bb901c-e41c-494f-aae8-7a5282f3bf96	f58f875c-2183-462f-9ef9-d34c20bd5748	{Schoolteacher}	21
75bb901c-e41c-494f-aae8-7a5282f3bf96	b3d271ee-f159-45dd-b774-cc823c21d82d	{"Kumayama's Henchman"}	24
75bb901c-e41c-494f-aae8-7a5282f3bf96	9e5948a3-3002-44bf-912e-5902e5f385f1	{Fisherman}	25
75bb901c-e41c-494f-aae8-7a5282f3bf96	0e2de731-55a7-44be-a0b3-8213183d631e	{Fisherman}	26
75bb901c-e41c-494f-aae8-7a5282f3bf96	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{Fisherman}	27
75bb901c-e41c-494f-aae8-7a5282f3bf96	885202f7-ebc0-41e6-91c8-761c1b65593a	{Fisherman}	28
75bb901c-e41c-494f-aae8-7a5282f3bf96	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	30
75bb901c-e41c-494f-aae8-7a5282f3bf96	ba759075-8927-42c2-8da7-58086e6f1e27	{Reporter}	32
75bb901c-e41c-494f-aae8-7a5282f3bf96	954bb729-459b-4676-b11b-912a33d3ca6d	{"Kumayama's Henchman"}	33
75bb901c-e41c-494f-aae8-7a5282f3bf96	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Soldier}	36
75bb901c-e41c-494f-aae8-7a5282f3bf96	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Soldier}	37
75bb901c-e41c-494f-aae8-7a5282f3bf96	2ebd5427-97aa-4b77-b5af-66a55ff46fc4	{Soldier}	38
75bb901c-e41c-494f-aae8-7a5282f3bf96	5dab35d1-8242-4af3-831c-2cb48b954f61	{Policeman}	40
75bb901c-e41c-494f-aae8-7a5282f3bf96	b883c489-0fe7-4165-86a4-49b531a28c37	{Islander}	44
75bb901c-e41c-494f-aae8-7a5282f3bf96	707ffa12-afe9-4ea9-b269-5c40f47d0620	{"Radio Operator"}	45
75bb901c-e41c-494f-aae8-7a5282f3bf96	f5b35e44-efd4-4298-8124-4bccd4325e23	{Godzilla}	47
75bb901c-e41c-494f-aae8-7a5282f3bf96	9b787e61-5c06-463d-aa62-18c142735fc8	{Godzilla}	48
75bb901c-e41c-494f-aae8-7a5282f3bf96	fe24405b-2c4d-479e-8f0c-0233a656f259	{"Military Advisor (American Version)"}	99
75bb901c-e41c-494f-aae8-7a5282f3bf96	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{"Hotel Clerk"}	99
75bb901c-e41c-494f-aae8-7a5282f3bf96	0887b3b0-a812-4501-8be9-2d25b4048d43	{"Reporter (American Version)"}	99
75bb901c-e41c-494f-aae8-7a5282f3bf96	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Soldier}	99
75bb901c-e41c-494f-aae8-7a5282f3bf96	3b4d8cf3-372d-4180-a625-d7ece05d7d58	{Islander}	99
75bb901c-e41c-494f-aae8-7a5282f3bf96	f38a2a42-a836-4c62-a1d5-265cba51076b	{Islander}	99
75bb901c-e41c-494f-aae8-7a5282f3bf96	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Reporter}	99
75bb901c-e41c-494f-aae8-7a5282f3bf96	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{Reporter}	99
75bb901c-e41c-494f-aae8-7a5282f3bf96	f9a23daa-fab8-418d-90f0-30a195ca171d	{Fisherman}	99
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	5e35fe94-1c41-4e60-a400-aa44c201deb1	{"Detective Komai"}	1
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	975efb7b-e01c-4ca2-9c8d-6deaddcf6ade	{"Masayo Kirino"}	2
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	34de1ef2-9428-4c7e-8512-5683f7cced38	{"Dr. Kirino"}	3
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	c0eeeca2-2862-4a6f-bf5b-66920a8172a8	{"Dr. Munakata"}	5
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	8880384d-16f9-4e12-b9c2-708c2ecaa93a	{"Gang Leader"}	6
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	7b5238d1-ec51-47fa-ae20-8f15e501944f	{"Mark Jackson"}	7
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	b86678a4-b0f5-477d-af53-af0dde7e60ef	{"General Iwata"}	8
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"Police Chief"}	9
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	86209caa-4d37-4745-be23-dbee24bf244a	{Gangster}	10
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	7890926d-3000-43b1-9be4-272609b3cca7	{Gangster}	11
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	6082d456-e1d7-43de-8174-148d1a2b09c0	{Gangster}	12
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	9d5454d0-b6de-4b62-bf4e-da467bd6c53b	{Gangster}	13
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	d9b9fe70-61d5-477e-b927-453ab57591c9	{Gangster}	14
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	37f86cbf-f363-4661-a911-94a2505f0da0	{"Detective Nitta"}	15
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	c21e21a8-e940-417c-982e-33aacb5e19a7	{Policeman}	16
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	2f7a44eb-826b-477e-973b-5c57a715b25a	{Soldier}	18
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	0e2de731-55a7-44be-a0b3-8213183d631e	{"Military Advisor"}	19
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	e55d872b-7180-48d9-a4ae-dbb5c3912e73	{"Truck Driver"}	20
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"Coal Miner"}	21
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	885202f7-ebc0-41e6-91c8-761c1b65593a	{"Coal Miner"}	22
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	9e5948a3-3002-44bf-912e-5902e5f385f1	{"Coal Miner"}	24
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	d85dc51d-4970-45b8-8b69-8472f0099fcb	{"Truck Driver"}	26
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	27
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{"Coal Miner"}	28
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Policeman}	32
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	b3d271ee-f159-45dd-b774-cc823c21d82d	{"Satellite Technician"}	33
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{"Coal Miner"}	34
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	954bb729-459b-4676-b11b-912a33d3ca6d	{"Train Attendant"}	99
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{Detective}	99
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	707ffa12-afe9-4ea9-b269-5c40f47d0620	{Soldier}	99
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	ba759075-8927-42c2-8da7-58086e6f1e27	{Soldier}	99
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	5dab35d1-8242-4af3-831c-2cb48b954f61	{Soldier}	99
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	e82833e4-7eee-4ef1-88e5-a285946593aa	{Soldier}	99
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Soldier}	99
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	b883c489-0fe7-4165-86a4-49b531a28c37	{Soldier}	99
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	f9a23daa-fab8-418d-90f0-30a195ca171d	{"Satellite Technician"}	99
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	5e35fe94-1c41-4e60-a400-aa44c201deb1	{"Detective Shindo"}	1
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	63df9c5e-35b7-4e72-9e6f-4bb8216f7842	{"Naoko Shindo"}	2
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	34de1ef2-9428-4c7e-8512-5683f7cced38	{"Dr. Murai"}	3
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	bd14a659-bf60-4b65-9ec2-514bad9ccb72	{"Dr. Tsukamoto"}	4
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	d08d501c-fb18-4360-8e59-9685b5ecead3	{"Princess Salno"}	6
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	0b33ac7b-829f-4140-b760-74806280cf6a	{Malmess}	7
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	949e61ea-2ba5-475d-8491-e784144eaf71	{Assassin}	8
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Chief Okita"}	9
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Newspaper Editor"}	10
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	2ef5fd75-6752-4e6b-ba59-02d2761e999e	{Assassin}	11
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	b41f2e59-2044-488c-b56f-8d3cfad0464c	{Geologist}	12
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	86209caa-4d37-4745-be23-dbee24bf244a	{"Cruise Ship Captain"}	13
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	7890926d-3000-43b1-9be4-272609b3cca7	{"Salno's Manservant"}	14
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	67eeac93-8584-4ffd-a380-2ef1dbc83ee2	{"Infant Island Chief"}	15
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	def945ba-826b-4d5a-b100-ce9eb2362805	{"Defense Minister"}	16
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	d03c3fe8-39fa-4083-8e8a-85e033e6b92e	{"Mrs. Shindo"}	17
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	d9b9fe70-61d5-477e-b927-453ab57591c9	{Reporter}	18
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	4aac5e75-0c01-418b-98fb-17d3f7138f85	{Fisherman}	19
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	113749dd-9700-4434-b8d7-4c55a7f00aa7	{General}	20
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	6de27671-6ff7-4603-beb5-1d683c42c4c2	{Parliamentarian}	21
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{"Sergina Opposition Leader"}	22
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	885202f7-ebc0-41e6-91c8-761c1b65593a	{"Mt. Aso Tourist"}	23
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	f79f33f2-2385-49c8-9c63-e6c118835713	{"Mt. Aso Tourist"}	24
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	478bc636-02cd-42e9-901c-a3acb24df07e	{"UFO Club President"}	25
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	0a4287a6-254e-42ce-b2fa-1a403c80947b	{Assassin}	26
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	c765ae89-2193-4416-a9d8-7136589d618c	{"TV Presenter"}	27
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	e3ab3196-10d7-4e5e-83cd-2426353915bd	{"TV Presenter"}	28
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"King Ghidorah",Villager}	29
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	8354c6a4-fa6b-4ac6-8f8a-d29ff1d1d3bb	{"UFO Club Member"}	30
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	c0aaff10-a67a-4304-a3c3-875a00348870	{Parliamentarian}	31
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	65171b44-fd3a-4948-9613-3f7206141774	{Volcanologist,Villager}	34
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	f5b35e44-efd4-4298-8124-4bccd4325e23	{Godzilla}	36
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{"Hotel Clerk"}	37
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	0e2de731-55a7-44be-a0b3-8213183d631e	{Parliamentarian}	41
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	2f7a44eb-826b-477e-973b-5c57a715b25a	{Parliamentarian}	42
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	f9a23daa-fab8-418d-90f0-30a195ca171d	{Reporter}	43
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{Sailor}	44
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	ba759075-8927-42c2-8da7-58086e6f1e27	{Bystander}	47
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{"Dam Worker"}	51
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{"UFO Club Member"}	99
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	9b787e61-5c06-463d-aa62-18c142735fc8	{Godzilla}	52
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	e82833e4-7eee-4ef1-88e5-a285946593aa	{Parliamentarian}	99
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Geologist}	54
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	2ebd5427-97aa-4b77-b5af-66a55ff46fc4	{Waiter}	99
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Reporter}	99
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	10af34fa-1751-4bfb-8950-3bd3667cc03f	{Rodan}	99
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{"Tsukamoto's Assistant"}	99
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Parliamentarian,"Serginan on Plane"}	99
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	5dab35d1-8242-4af3-831c-2cb48b954f61	{"Prime Minister"}	99
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	f38a2a42-a836-4c62-a1d5-265cba51076b	{"Serginan Official"}	99
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	ff76604e-909d-489b-8c32-64de3d04a0fc	{"Dr. Yuzo Kawaji"}	1
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	dd78923c-483a-474d-9b5a-11d4cc6b72dc	{"Dr. James Bowen"}	2
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	22c73667-bbd2-41e1-93ed-45913b29fe29	{"Dr. Sueko Togami"}	3
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	06adecc6-cbbe-4893-a916-16e683448590	{Kawai}	4
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	54bbf86b-1738-4b48-a846-745cac5fd622	{Frankenstein}	5
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"Officer Nishi"}	6
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	b86678a4-b0f5-477d-af53-af0dde7e60ef	{"Osaka Police Chief"}	7
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	bd14a659-bf60-4b65-9ec2-514bad9ccb72	{"Axis Scientist"}	8
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	c0eeeca2-2862-4a6f-bf5b-66920a8172a8	{"Skeptical Museum Curator"}	9
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{Policeman}	10
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	0b33ac7b-829f-4140-b760-74806280cf6a	{Policeman}	11
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	86209caa-4d37-4745-be23-dbee24bf244a	{"Axis Submarine Captain"}	12
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	b41f2e59-2044-488c-b56f-8d3cfad0464c	{Reporter}	13
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	d9b9fe70-61d5-477e-b927-453ab57591c9	{"TV Reporter"}	14
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	4aac5e75-0c01-418b-98fb-17d3f7138f85	{"Man Walking Dog"}	15
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	67eeac93-8584-4ffd-a380-2ef1dbc83ee2	{Soldier}	16
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	89722c18-a818-49a3-8bea-27e46eaa150f	{Kazuko}	18
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	8b35d3c7-019e-4371-b402-96f7c8cae0a9	{"Dr. Liesendorf"}	20
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	56679376-b60c-4926-ae33-3c99ae021778	{"Kawai's Assistant"}	21
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{"Laboratory Administrator"}	22
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	060bffd0-c2bc-4a01-8928-e4921c6ea447	{"Skeptical Reporter"}	23
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	6de27671-6ff7-4603-beb5-1d683c42c4c2	{"Skeptical Scientist"}	24
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	9b787e61-5c06-463d-aa62-18c142735fc8	{Baragon}	25
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	885202f7-ebc0-41e6-91c8-761c1b65593a	{"TV Reporter"}	26
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	f79f33f2-2385-49c8-9c63-e6c118835713	{"TV Cameraman"}	27
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	6082d456-e1d7-43de-8174-148d1a2b09c0	{Policeman}	28
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	3e42b352-0c52-4e39-b028-7b5a8b45e415	{Reporter}	29
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	{Policeman}	30
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{Miner}	31
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	c0aaff10-a67a-4304-a3c3-875a00348870	{"Village Policeman"}	32
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	2f7a44eb-826b-477e-973b-5c57a715b25a	{Miner}	34
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	36
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{Villager}	99
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Reporter}	38
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	d85dc51d-4970-45b8-8b69-8472f0099fcb	{"Axis Soldier"}	99
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Reporter}	39
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	707ffa12-afe9-4ea9-b269-5c40f47d0620	{Reporter}	99
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	b883c489-0fe7-4165-86a4-49b531a28c37	{Soldier}	40
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	f9a23daa-fab8-418d-90f0-30a195ca171d	{Bystander}	99
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Scientist}	99
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	f38a2a42-a836-4c62-a1d5-265cba51076b	{Scientist}	99
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Reporter}	99
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	e82833e4-7eee-4ef1-88e5-a285946593aa	{Policeman}	99
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{Policeman}	99
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	2aec7762-810f-40b3-943c-211bc049d319	{"Astronaut Fuji"}	1
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	dd78923c-483a-474d-9b5a-11d4cc6b72dc	{"Astronaut Glenn"}	2
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	22c73667-bbd2-41e1-93ed-45913b29fe29	{Namikawa}	3
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	89722c18-a818-49a3-8bea-27e46eaa150f	{"Haruno Fuji"}	4
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"Dr. Sakurai"}	5
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	06adecc6-cbbe-4893-a916-16e683448590	{"The Controller of Planet X"}	6
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	4ba64419-409e-4f61-bd6e-d4a651cfe3e5	{Tetsuo}	7
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	770edee6-77a7-4d9f-99f0-427750ae7aa5	{"Prime Minister"}	8
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	3881d7da-94c0-408b-b384-1133f2c55f46	{Minister}	9
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	86209caa-4d37-4745-be23-dbee24bf244a	{Soldier}	10
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	060bffd0-c2bc-4a01-8928-e4921c6ea447	{"Xian Commander"}	11
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	6032ee2a-e49e-43be-b727-dfda0a12c60f	{"Tetsuo's Landlady"}	12
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	478bc636-02cd-42e9-901c-a3acb24df07e	{Priest}	13
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	2e3fbeb0-3e78-49ba-8cc1-7172e66b26f9	{General}	14
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	2ef5fd75-6752-4e6b-ba59-02d2761e999e	{Xian}	15
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	0a4287a6-254e-42ce-b2fa-1a403c80947b	{Xian}	16
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	c21e21a8-e940-417c-982e-33aacb5e19a7	{Soldier}	17
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	6082d456-e1d7-43de-8174-148d1a2b09c0	{Soldier}	18
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	f9094a20-8286-4b66-bd41-eafd905c9d83	{Minister}	19
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	2f7a44eb-826b-477e-973b-5c57a715b25a	{Soldier}	20
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	0e2de731-55a7-44be-a0b3-8213183d631e	{Soldier}	21
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{Xian}	22
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Scientist}	23
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	b883c489-0fe7-4165-86a4-49b531a28c37	{Soldier}	25
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Reporter}	26
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{Reporter}	29
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Reporter}	30
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	9b787e61-5c06-463d-aa62-18c142735fc8	{Godzilla}	31
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	10af34fa-1751-4bfb-8950-3bd3667cc03f	{Rodan}	32
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"King Ghidorah"}	33
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	e82833e4-7eee-4ef1-88e5-a285946593aa	{"Military Advisor"}	99
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	707ffa12-afe9-4ea9-b269-5c40f47d0620	{Xian}	99
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	9d5454d0-b6de-4b62-bf4e-da467bd6c53b	{Xian}	99
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{Scientist}	99
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Soldier}	99
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	5dab35d1-8242-4af3-831c-2cb48b954f61	{Minister}	99
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	839d802a-34c1-4258-a75a-2a5bbfe67afc	{Scientist}	99
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	f9a23daa-fab8-418d-90f0-30a195ca171d	{Xian}	99
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	5240cb5f-b0a8-4c64-aa01-93a65b45d419	{"Radio Announcer"}	99
23c1c82e-aedb-4c9b-b040-c780eec577e8	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Dr. Yuzo Majida"}	1
23c1c82e-aedb-4c9b-b040-c780eec577e8	22c73667-bbd2-41e1-93ed-45913b29fe29	{Akemi}	2
23c1c82e-aedb-4c9b-b040-c780eec577e8	d857a341-b082-4338-906c-f3ba566a9d3b	{"Dr. Paul Stewart"}	3
23c1c82e-aedb-4c9b-b040-c780eec577e8	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"General Hashimoto"}	4
23c1c82e-aedb-4c9b-b040-c780eec577e8	79c3e233-566d-4d53-8fb0-87a1383ae3c8	{"Nightclub Singer"}	5
23c1c82e-aedb-4c9b-b040-c780eec577e8	86209caa-4d37-4745-be23-dbee24bf244a	{"Coast Guard"}	6
23c1c82e-aedb-4c9b-b040-c780eec577e8	c0eeeca2-2862-4a6f-bf5b-66920a8172a8	{"Dr. Kida"}	7
23c1c82e-aedb-4c9b-b040-c780eec577e8	0b33ac7b-829f-4140-b760-74806280cf6a	{"Coast Guard"}	8
23c1c82e-aedb-4c9b-b040-c780eec577e8	6082d456-e1d7-43de-8174-148d1a2b09c0	{Soldier}	9
23c1c82e-aedb-4c9b-b040-c780eec577e8	c21e21a8-e940-417c-982e-33aacb5e19a7	{Soldier}	10
23c1c82e-aedb-4c9b-b040-c780eec577e8	8354c6a4-fa6b-4ac6-8f8a-d29ff1d1d3bb	{Doctor}	11
23c1c82e-aedb-4c9b-b040-c780eec577e8	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{Guide}	12
23c1c82e-aedb-4c9b-b040-c780eec577e8	b41f2e59-2044-488c-b56f-8d3cfad0464c	{Soldier}	13
23c1c82e-aedb-4c9b-b040-c780eec577e8	4aac5e75-0c01-418b-98fb-17d3f7138f85	{Fisherman}	14
23c1c82e-aedb-4c9b-b040-c780eec577e8	56679376-b60c-4926-ae33-3c99ae021778	{Sailor}	15
23c1c82e-aedb-4c9b-b040-c780eec577e8	3e42b352-0c52-4e39-b028-7b5a8b45e415	{Bystander}	17
23c1c82e-aedb-4c9b-b040-c780eec577e8	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Soldier}	19
23c1c82e-aedb-4c9b-b040-c780eec577e8	2f7a44eb-826b-477e-973b-5c57a715b25a	{Soldier}	20
23c1c82e-aedb-4c9b-b040-c780eec577e8	b3d271ee-f159-45dd-b774-cc823c21d82d	{"Air Traffic Controller"}	21
23c1c82e-aedb-4c9b-b040-c780eec577e8	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Reporter}	24
23c1c82e-aedb-4c9b-b040-c780eec577e8	f9a23daa-fab8-418d-90f0-30a195ca171d	{Reporter}	25
23c1c82e-aedb-4c9b-b040-c780eec577e8	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Reporter}	26
23c1c82e-aedb-4c9b-b040-c780eec577e8	9e5948a3-3002-44bf-912e-5902e5f385f1	{"Military Advisor"}	27
23c1c82e-aedb-4c9b-b040-c780eec577e8	0e2de731-55a7-44be-a0b3-8213183d631e	{"Military Advisor"}	28
23c1c82e-aedb-4c9b-b040-c780eec577e8	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Reporter}	31
23c1c82e-aedb-4c9b-b040-c780eec577e8	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	32
23c1c82e-aedb-4c9b-b040-c780eec577e8	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Reporter}	33
23c1c82e-aedb-4c9b-b040-c780eec577e8	9b787e61-5c06-463d-aa62-18c142735fc8	{Gaira}	34
23c1c82e-aedb-4c9b-b040-c780eec577e8	f02a3856-95fc-4e5b-8d58-9f733e3b2278	{Sanda}	35
23c1c82e-aedb-4c9b-b040-c780eec577e8	e230df43-9ff7-46ea-8e2a-a1f31a2b3204	{"Dr. Paul Stewart (Voice)"}	36
23c1c82e-aedb-4c9b-b040-c780eec577e8	e82833e4-7eee-4ef1-88e5-a285946593aa	{"Military Advisor"}	99
23c1c82e-aedb-4c9b-b040-c780eec577e8	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{Reporter}	99
23c1c82e-aedb-4c9b-b040-c780eec577e8	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{Soldier}	99
23c1c82e-aedb-4c9b-b040-c780eec577e8	5dab35d1-8242-4af3-831c-2cb48b954f61	{"Military Advisor"}	99
23c1c82e-aedb-4c9b-b040-c780eec577e8	2ebd5427-97aa-4b77-b5af-66a55ff46fc4	{Fisherman}	99
23c1c82e-aedb-4c9b-b040-c780eec577e8	b883c489-0fe7-4165-86a4-49b531a28c37	{Soldier}	99
f474852a-cc25-477d-a7b9-06aa688f7fb2	2aec7762-810f-40b3-943c-211bc049d319	{Yoshimura}	1
f474852a-cc25-477d-a7b9-06aa688f7fb2	22c73667-bbd2-41e1-93ed-45913b29fe29	{Daiyo}	2
f474852a-cc25-477d-a7b9-06aa688f7fb2	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"Red Bamboo Commander"}	4
f474852a-cc25-477d-a7b9-06aa688f7fb2	a860b944-2633-47f3-bea6-8f6a2dece2ff	{Nita}	5
f474852a-cc25-477d-a7b9-06aa688f7fb2	e55d872b-7180-48d9-a4ae-dbb5c3912e73	{Ichino}	6
f474852a-cc25-477d-a7b9-06aa688f7fb2	2ef5fd75-6752-4e6b-ba59-02d2761e999e	{Yata}	7
f474852a-cc25-477d-a7b9-06aa688f7fb2	a536e565-3ef4-4187-87d7-7b064855fddd	{Ryota}	8
f474852a-cc25-477d-a7b9-06aa688f7fb2	7890926d-3000-43b1-9be4-272609b3cca7	{"Red Bamboo Officer"}	9
f474852a-cc25-477d-a7b9-06aa688f7fb2	4aac5e75-0c01-418b-98fb-17d3f7138f85	{"Captive Islander"}	10
f474852a-cc25-477d-a7b9-06aa688f7fb2	6de27671-6ff7-4603-beb5-1d683c42c4c2	{"Newspaper Editor"}	12
f474852a-cc25-477d-a7b9-06aa688f7fb2	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"Escaped Islander"}	13
f474852a-cc25-477d-a7b9-06aa688f7fb2	0a4287a6-254e-42ce-b2fa-1a403c80947b	{"Escaped Islander"}	14
f474852a-cc25-477d-a7b9-06aa688f7fb2	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{Villager}	15
f474852a-cc25-477d-a7b9-06aa688f7fb2	7c2734fd-8980-4ca8-b562-20f07dab5641	{"Yata's & Ryota's Mother"}	17
f474852a-cc25-477d-a7b9-06aa688f7fb2	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{"Red Bamboo Scientist"}	19
f474852a-cc25-477d-a7b9-06aa688f7fb2	b3d271ee-f159-45dd-b774-cc823c21d82d	{Reporter}	20
f474852a-cc25-477d-a7b9-06aa688f7fb2	3b4d8cf3-372d-4180-a625-d7ece05d7d58	{Reporter}	21
f474852a-cc25-477d-a7b9-06aa688f7fb2	b883c489-0fe7-4165-86a4-49b531a28c37	{"Red Bamboo Soldier"}	22
f474852a-cc25-477d-a7b9-06aa688f7fb2	65171b44-fd3a-4948-9613-3f7206141774	{Policeman}	24
f474852a-cc25-477d-a7b9-06aa688f7fb2	9b787e61-5c06-463d-aa62-18c142735fc8	{Godzilla}	25
f474852a-cc25-477d-a7b9-06aa688f7fb2	f02a3856-95fc-4e5b-8d58-9f733e3b2278	{Ebirah}	26
f474852a-cc25-477d-a7b9-06aa688f7fb2	954bb729-459b-4676-b11b-912a33d3ca6d	{"Red Bamboo Soldier"}	99
f474852a-cc25-477d-a7b9-06aa688f7fb2	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{"Captive Islander"}	99
f474852a-cc25-477d-a7b9-06aa688f7fb2	0b33ac7b-829f-4140-b760-74806280cf6a	{"Red Bamboo Scientist"}	11
f474852a-cc25-477d-a7b9-06aa688f7fb2	f9a23daa-fab8-418d-90f0-30a195ca171d	{"Captive Islander","Red Bamboo Soldier"}	23
ba6031ef-c7b0-451c-8465-cb2a3c494896	2aec7762-810f-40b3-943c-211bc049d319	{"Lt. Jiro Nomura"}	1
ba6031ef-c7b0-451c-8465-cb2a3c494896	ca42052c-b7db-4e90-a825-bf0afe11a5b9	{"Madame Piranha"}	2
ba6031ef-c7b0-451c-8465-cb2a3c494896	b6c06259-91a2-4c9f-ae59-1ccedf1f3b58	{"Carl Nelson"}	3
ba6031ef-c7b0-451c-8465-cb2a3c494896	9615ed46-f166-4c51-b737-a25a0de312c3	{"Susan Watson"}	4
ba6031ef-c7b0-451c-8465-cb2a3c494896	7890926d-3000-43b1-9be4-272609b3cca7	{"Dr. Who"}	5
ba6031ef-c7b0-451c-8465-cb2a3c494896	86209caa-4d37-4745-be23-dbee24bf244a	{"Who Henchman"}	6
ba6031ef-c7b0-451c-8465-cb2a3c494896	bf17ae68-1ab5-48b3-93f8-12876984d814	{"Who Henchman"}	7
ba6031ef-c7b0-451c-8465-cb2a3c494896	4aac5e75-0c01-418b-98fb-17d3f7138f85	{Islander}	9
ba6031ef-c7b0-451c-8465-cb2a3c494896	6082d456-e1d7-43de-8174-148d1a2b09c0	{"Who Henchman"}	10
ba6031ef-c7b0-451c-8465-cb2a3c494896	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{"Submarine Crew"}	11
ba6031ef-c7b0-451c-8465-cb2a3c494896	0a4287a6-254e-42ce-b2fa-1a403c80947b	{"Who Henchman"}	12
ba6031ef-c7b0-451c-8465-cb2a3c494896	2ef5fd75-6752-4e6b-ba59-02d2761e999e	{"Who Henchman"}	13
ba6031ef-c7b0-451c-8465-cb2a3c494896	415eddaf-1711-4795-9381-bc001c89b0a7	{"Who Henchman"}	14
ba6031ef-c7b0-451c-8465-cb2a3c494896	949e61ea-2ba5-475d-8491-e784144eaf71	{"Who Henchman"}	15
ba6031ef-c7b0-451c-8465-cb2a3c494896	9b787e61-5c06-463d-aa62-18c142735fc8	{Bystander,"King Kong"}	16
ba6031ef-c7b0-451c-8465-cb2a3c494896	f02a3856-95fc-4e5b-8d58-9f733e3b2278	{Gorosaurus,Mechani-Kong}	17
ba6031ef-c7b0-451c-8465-cb2a3c494896	18fd187f-354e-4318-b6f1-71ac2b35e169	{"Who Henchman"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	2ebd5427-97aa-4b77-b5af-66a55ff46fc4	{"Who Henchman"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{Soldier}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	f9a23daa-fab8-418d-90f0-30a195ca171d	{"Who Henchman"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{"Submarine Crew"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	707ffa12-afe9-4ea9-b269-5c40f47d0620	{"Who Henchman"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	d85dc51d-4970-45b8-8b69-8472f0099fcb	{Soldier}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	65171b44-fd3a-4948-9613-3f7206141774	{"Submarine Crew"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{"Military Advisor"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	839d802a-34c1-4258-a75a-2a5bbfe67afc	{"Military Advisor"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Soldier}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	0887b3b0-a812-4501-8be9-2d25b4048d43	{"Submarine Crew"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	b883c489-0fe7-4165-86a4-49b531a28c37	{"Submarine Crew"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	dce8d29d-b85c-4394-80f8-5e3c910f391f	{"UN Reporter"}	99
ba6031ef-c7b0-451c-8465-cb2a3c494896	e82833e4-7eee-4ef1-88e5-a285946593aa	{Soldier}	99
40cb6fad-15b4-46f5-8066-273cb965c3c4	ff76604e-909d-489b-8c32-64de3d04a0fc	{"Dr. Kusumi"}	1
40cb6fad-15b4-46f5-8066-273cb965c3c4	69bf5524-7df6-4af9-bf93-b646a935ed53	{Saeko}	2
40cb6fad-15b4-46f5-8066-273cb965c3c4	4ba64419-409e-4f61-bd6e-d4a651cfe3e5	{"Goro Maki"}	3
40cb6fad-15b4-46f5-8066-273cb965c3c4	792be715-31b9-4b8c-8ddf-38fbea1e4101	{Fujisaki}	4
40cb6fad-15b4-46f5-8066-273cb965c3c4	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{Morio}	5
40cb6fad-15b4-46f5-8066-273cb965c3c4	06adecc6-cbbe-4893-a916-16e683448590	{Furukawa}	6
40cb6fad-15b4-46f5-8066-273cb965c3c4	949e61ea-2ba5-475d-8491-e784144eaf71	{Pilot}	7
40cb6fad-15b4-46f5-8066-273cb965c3c4	0a4287a6-254e-42ce-b2fa-1a403c80947b	{Pilot}	8
40cb6fad-15b4-46f5-8066-273cb965c3c4	3b4d8cf3-372d-4180-a625-d7ece05d7d58	{Ozawa}	9
40cb6fad-15b4-46f5-8066-273cb965c3c4	2ebd5427-97aa-4b77-b5af-66a55ff46fc4	{Tashiro}	10
40cb6fad-15b4-46f5-8066-273cb965c3c4	3e42b352-0c52-4e39-b028-7b5a8b45e415	{Suzuki}	11
40cb6fad-15b4-46f5-8066-273cb965c3c4	e55d872b-7180-48d9-a4ae-dbb5c3912e73	{Pilot}	12
40cb6fad-15b4-46f5-8066-273cb965c3c4	b3d271ee-f159-45dd-b774-cc823c21d82d	{Pilot}	13
40cb6fad-15b4-46f5-8066-273cb965c3c4	479f2ab3-c3c5-4049-8b4e-99367ceb893d	{Godzilla}	14
40cb6fad-15b4-46f5-8066-273cb965c3c4	f02a3856-95fc-4e5b-8d58-9f733e3b2278	{Godzilla}	15
40cb6fad-15b4-46f5-8066-273cb965c3c4	9b787e61-5c06-463d-aa62-18c142735fc8	{Godzilla}	16
40cb6fad-15b4-46f5-8066-273cb965c3c4	91f549ac-d460-44e6-b2d3-70b96cb593de	{Minya}	17
40cb6fad-15b4-46f5-8066-273cb965c3c4	0887b3b0-a812-4501-8be9-2d25b4048d43	{"Submarine Officer"}	99
7be35dd2-8758-4cb8-85af-17985772d431	4ba64419-409e-4f61-bd6e-d4a651cfe3e5	{"Katsuo Yamabe"}	1
7be35dd2-8758-4cb8-85af-17985772d431	2f955981-68a8-4db4-9d3a-3f0f81321ff0	{"Kyoko Manabe"}	2
7be35dd2-8758-4cb8-85af-17985772d431	bee0c590-edb2-4f54-8d6a-7e105e2ed741	{"Kilaak Queen"}	3
7be35dd2-8758-4cb8-85af-17985772d431	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"Dr, Yoshido"}	4
7be35dd2-8758-4cb8-85af-17985772d431	06adecc6-cbbe-4893-a916-16e683448590	{"Dr. Otani"}	5
7be35dd2-8758-4cb8-85af-17985772d431	0b33ac7b-829f-4140-b760-74806280cf6a	{"Major Tada"}	8
7be35dd2-8758-4cb8-85af-17985772d431	86209caa-4d37-4745-be23-dbee24bf244a	{"Defense Chief Sugiyama"}	9
7be35dd2-8758-4cb8-85af-17985772d431	6082d456-e1d7-43de-8174-148d1a2b09c0	{"Special Police"}	10
7be35dd2-8758-4cb8-85af-17985772d431	415eddaf-1711-4795-9381-bc001c89b0a7	{"Special Police"}	11
7be35dd2-8758-4cb8-85af-17985772d431	4aac5e75-0c01-418b-98fb-17d3f7138f85	{Mountaineer}	12
7be35dd2-8758-4cb8-85af-17985772d431	b3d271ee-f159-45dd-b774-cc823c21d82d	{"SY-3 Pilot"}	13
7be35dd2-8758-4cb8-85af-17985772d431	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{"Village Policeman"}	15
7be35dd2-8758-4cb8-85af-17985772d431	e55d872b-7180-48d9-a4ae-dbb5c3912e73	{"SY-3 Pilot Ogata"}	16
7be35dd2-8758-4cb8-85af-17985772d431	3e42b352-0c52-4e39-b028-7b5a8b45e415	{"SY-3 Pilot"}	17
7be35dd2-8758-4cb8-85af-17985772d431	2ebd5427-97aa-4b77-b5af-66a55ff46fc4	{"SY-3 Pilot"}	18
7be35dd2-8758-4cb8-85af-17985772d431	3b4d8cf3-372d-4180-a625-d7ece05d7d58	{"Moon Base Tech"}	19
7be35dd2-8758-4cb8-85af-17985772d431	ba759075-8927-42c2-8da7-58086e6f1e27	{"SY-3 Pilot"}	21
7be35dd2-8758-4cb8-85af-17985772d431	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	23
7be35dd2-8758-4cb8-85af-17985772d431	f9a23daa-fab8-418d-90f0-30a195ca171d	{"UNSC Tech"}	24
7be35dd2-8758-4cb8-85af-17985772d431	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{"Special Police"}	25
7be35dd2-8758-4cb8-85af-17985772d431	949e61ea-2ba5-475d-8491-e784144eaf71	{"Possessed Monster Island Tech"}	7
7be35dd2-8758-4cb8-85af-17985772d431	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{"Mt. Fuji Reporter"}	26
7be35dd2-8758-4cb8-85af-17985772d431	d85dc51d-4970-45b8-8b69-8472f0099fcb	{"Military Advisor"}	27
7be35dd2-8758-4cb8-85af-17985772d431	b883c489-0fe7-4165-86a4-49b531a28c37	{"Military Advisor"}	28
7be35dd2-8758-4cb8-85af-17985772d431	954bb729-459b-4676-b11b-912a33d3ca6d	{Soldier}	29
7be35dd2-8758-4cb8-85af-17985772d431	fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	{Reporter}	30
7be35dd2-8758-4cb8-85af-17985772d431	9b787e61-5c06-463d-aa62-18c142735fc8	{Godzilla,"Military Advisor"}	36
7be35dd2-8758-4cb8-85af-17985772d431	f02a3856-95fc-4e5b-8d58-9f733e3b2278	{Anguirus,Gorosaurus}	37
7be35dd2-8758-4cb8-85af-17985772d431	5360ea2f-63f4-4453-9ffc-853586496732	{Rodan}	38
7be35dd2-8758-4cb8-85af-17985772d431	3dae06b9-b139-4c1d-b3db-e23ffe8d135c	{"King Ghidorah"}	39
7be35dd2-8758-4cb8-85af-17985772d431	91f549ac-d460-44e6-b2d3-70b96cb593de	{Minya}	40
7be35dd2-8758-4cb8-85af-17985772d431	5240cb5f-b0a8-4c64-aa01-93a65b45d419	{"Radio Announcer"}	41
7be35dd2-8758-4cb8-85af-17985772d431	8354c6a4-fa6b-4ac6-8f8a-d29ff1d1d3bb	{"UNSC Scientist"}	42
7be35dd2-8758-4cb8-85af-17985772d431	dce8d29d-b85c-4394-80f8-5e3c910f391f	{"Dr. Stevenson"}	43
7be35dd2-8758-4cb8-85af-17985772d431	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{"Military Advisor"}	99
7be35dd2-8758-4cb8-85af-17985772d431	839d802a-34c1-4258-a75a-2a5bbfe67afc	{"Military Advisor"}	99
7be35dd2-8758-4cb8-85af-17985772d431	be4ac231-b431-4c18-b5a9-851e2a7713f1	{"Military Advisor"}	99
7be35dd2-8758-4cb8-85af-17985772d431	20f64b6e-c968-4cf2-b195-76561d8acea6	{Reporter}	99
7be35dd2-8758-4cb8-85af-17985772d431	e82833e4-7eee-4ef1-88e5-a285946593aa	{"Monster Island Tech","Military Advisor"}	99
7be35dd2-8758-4cb8-85af-17985772d431	0e2de731-55a7-44be-a0b3-8213183d631e	{Reporter}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	2aec7762-810f-40b3-943c-211bc049d319	{"Hideto Ogata"}	1
653335e2-101e-4303-90a2-eb71dac3c6e3	9bf7c6b0-5a5f-485d-80e1-4fe6a1241bfd	{"Emiko Yamane"}	2
653335e2-101e-4303-90a2-eb71dac3c6e3	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Dr. Daisuke Serizawa"}	3
653335e2-101e-4303-90a2-eb71dac3c6e3	bd14a659-bf60-4b65-9ec2-514bad9ccb72	{"Dr. Kyohei Yamane"}	4
653335e2-101e-4303-90a2-eb71dac3c6e3	3881d7da-94c0-408b-b384-1133f2c55f46	{"Dr. Tanabe"}	5
653335e2-101e-4303-90a2-eb71dac3c6e3	bf17ae68-1ab5-48b3-93f8-12876984d814	{Hagiwara}	6
653335e2-101e-4303-90a2-eb71dac3c6e3	56679376-b60c-4926-ae33-3c99ae021778	{Masaji}	8
653335e2-101e-4303-90a2-eb71dac3c6e3	f03e5540-5215-405b-8641-1b3f60ebe755	{"Diet Chairman"}	9
653335e2-101e-4303-90a2-eb71dac3c6e3	468e289d-6838-4fb7-b710-7b47a209e5d0	{Parliamentarian}	10
653335e2-101e-4303-90a2-eb71dac3c6e3	600f3ec6-2ba2-4c6d-8cc1-01f4d625755b	{"Defense Secretary"}	11
653335e2-101e-4303-90a2-eb71dac3c6e3	f38a2a42-a836-4c62-a1d5-265cba51076b	{"Mayor Inada"}	12
653335e2-101e-4303-90a2-eb71dac3c6e3	0c704bd2-886c-4acc-8b83-f0b9b7ee8aac	{Shinkichi}	13
653335e2-101e-4303-90a2-eb71dac3c6e3	135f83a7-6249-4068-b8ba-4319b3a2b49e	{Izuma}	14
653335e2-101e-4303-90a2-eb71dac3c6e3	daffb7f5-4b0c-4e00-96c4-6ac19b15d22b	{Parliamentarian}	15
653335e2-101e-4303-90a2-eb71dac3c6e3	7102d855-7fc6-4668-b20e-38fe1e3705cf	{"Cruise Passenger"}	17
653335e2-101e-4303-90a2-eb71dac3c6e3	ba096bb3-4c76-453a-8d6a-86a01d2e0337	{"Yamane's Assistant"}	19
653335e2-101e-4303-90a2-eb71dac3c6e3	97417c8f-8ba2-463d-a9d6-dac0810125be	{"Cruise Passenger"}	20
653335e2-101e-4303-90a2-eb71dac3c6e3	f9221586-cca1-42ce-82c9-310042ffe9fe	{"Coast Guard"}	21
653335e2-101e-4303-90a2-eb71dac3c6e3	be4ac231-b431-4c18-b5a9-851e2a7713f1	{"Doomed Reporter"}	22
653335e2-101e-4303-90a2-eb71dac3c6e3	c21e21a8-e940-417c-982e-33aacb5e19a7	{Islander}	24
653335e2-101e-4303-90a2-eb71dac3c6e3	5240cb5f-b0a8-4c64-aa01-93a65b45d419	{Reporter}	26
653335e2-101e-4303-90a2-eb71dac3c6e3	1cfeedcd-f22a-4d2a-9858-491a773d65ad	{"Defense Official"}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	0e2de731-55a7-44be-a0b3-8213183d631e	{"Defense Official"}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	235193ac-7eb5-4514-b03d-cefab039ed5f	{"Ship's Radio Operator"}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	{Parliamentarian}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	acace893-b445-4425-98d9-09126f7dcbf6	{"Coast Guard"}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{"Substation Operator"}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	65171b44-fd3a-4948-9613-3f7206141774	{Reporter}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	92dd9d68-0b73-443a-8aae-f0e7bba34f32	{"Coast Guard"}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	ba759075-8927-42c2-8da7-58086e6f1e27	{Sailor}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	8e70dd9b-5105-49c4-9bdf-ba558a60f593	{Correspondent}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	2f7a44eb-826b-477e-973b-5c57a715b25a	{Policeman}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	b883c489-0fe7-4165-86a4-49b531a28c37	{"Radio Operator"}	99
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	006a5098-4f81-40eb-8f8e-785e6f43a956	{Osami}	1
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	27bfdcc6-5f02-47fd-ae38-7ea8d9fac219	{"The King"}	2
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	99d628a5-b63c-4bf4-ae4e-1290b618f02f	{Ensai}	3
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	7e735ef6-b865-424d-9291-0387716327cb	{"Gorjaka the Bandit"}	4
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	ba66d21c-9c9a-4290-848e-a89f3a2ce28d	{"The Queen"}	7
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	19291744-943e-4d56-a006-f82021b01e1a	{"The Wizard Hermit"}	8
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	0cd551b9-f7a4-4bdf-b0e5-050c835f1096	{"The Innkeeper"}	9
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"The Chamberlain"}	10
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	949e61ea-2ba5-475d-8491-e784144eaf71	{"Palace Guard"}	11
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	7890926d-3000-43b1-9be4-272609b3cca7	{"Granny the Witch"}	12
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	7c32641a-4525-485a-aeb6-b7cdf4baf19e	{"Osami's Brother"}	13
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	439b033b-b72a-4ed0-b2fd-c44468378bc0	{"The Queen's Handmaiden"}	14
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	32b3608c-6052-4ea4-9f14-38fa182a0340	{Sundara}	15
653335e2-101e-4303-90a2-eb71dac3c6e3	839d802a-34c1-4258-a75a-2a5bbfe67afc	{"Defense Official","Radio Operator"}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{Reporter,"Cruise Passenger"}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	c0aaff10-a67a-4304-a3c3-875a00348870	{Reporter,"Defense Official"}	99
653335e2-101e-4303-90a2-eb71dac3c6e3	9b787e61-5c06-463d-aa62-18c142735fc8	{Godzilla,"Newspaper Reporter"}	28
653335e2-101e-4303-90a2-eb71dac3c6e3	f5b35e44-efd4-4298-8124-4bccd4325e23	{Godzilla,"Newspaper Editor"}	27
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	ca42052c-b7db-4e90-a825-bf0afe11a5b9	{Kureya}	5
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	d08d501c-fb18-4360-8e59-9685b5ecead3	{Spriya}	6
653335e2-101e-4303-90a2-eb71dac3c6e3	ef73315d-624c-4436-a729-5e47d474365e	{"Fishing Company President"}	7
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	bf17ae68-1ab5-48b3-93f8-12876984d814	{"Caravan Leader"}	16
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	6de27671-6ff7-4603-beb5-1d683c42c4c2	{"Royal Advisor"}	17
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	06d3db81-7ec1-4f1c-9df6-e210dba769b2	{"Royal Advisor"}	18
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	415eddaf-1711-4795-9381-bc001c89b0a7	{"Palace Guard"}	19
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	56679376-b60c-4926-ae33-3c99ae021778	{"Jail Keeper"}	20
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	4aac5e75-0c01-418b-98fb-17d3f7138f85	{"Slave Auctioneer"}	21
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	def945ba-826b-4d5a-b100-ce9eb2362805	{"Buddhist Priest"}	22
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	fd1d5a32-95c6-45da-8b27-99e6f9b8b9af	{"Palace Guard"}	22
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	9e5948a3-3002-44bf-912e-5902e5f385f1	{Merchant}	27
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{Villager}	99
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	f9a23daa-fab8-418d-90f0-30a195ca171d	{Villager}	99
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	954bb729-459b-4676-b11b-912a33d3ca6d	{"Palace Guard"}	99
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	{Villager}	99
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	f38a2a42-a836-4c62-a1d5-265cba51076b	{Villager}	99
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	be4ac231-b431-4c18-b5a9-851e2a7713f1	{Villager}	99
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	55568fbd-5fe6-4dad-806a-b7b0d89ffdc5	{"Dr. Toru Isobe"}	1
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	8b799dcc-7588-403b-80f8-c0d4467c2019	{"Hikari Aozora","Ginko Amano"}	2
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	2a416760-6248-4c35-a23e-b8f6becf0f88	{"Dr. Eisuke Matsuda"}	4
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	1e37d5f2-45c2-490b-915d-ba87309ae4ca	{"Dr. Naotaro Isobe"}	5
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	686f2dc2-a12d-4f46-af2f-b0d3c81069c9	{"Dr. Yoshio Komura"}	6
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	524b444f-a3c5-4fd2-b5a1-919939b43c4c	{"Tomoko Komura"}	7
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	1ec4e3df-c02f-44fd-a7cc-6b842bf44bb4	{"Kiyoko Matsuda"}	8
653335e2-101e-4303-90a2-eb71dac3c6e3	505a2aab-1965-4e16-a6b4-697e14d85d1a	{Parliamentarian}	99
7f9c68a7-8cec-4f4e-be97-528fe66605c3	23034690-67d2-4b91-a857-a04f9f810deb	{"Branch Manager Shibeki"}	7
f474852a-cc25-477d-a7b9-06aa688f7fb2	792be715-31b9-4b8c-8ddf-38fbea1e4101	{"Red Bamboo Captain Yamoto"}	3
7be35dd2-8758-4cb8-85af-17985772d431	0a4287a6-254e-42ce-b2fa-1a403c80947b	{"Possessed Monster Island Tech"}	14
7be35dd2-8758-4cb8-85af-17985772d431	b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	{"Possessed Monster Island Tech"}	22
7be35dd2-8758-4cb8-85af-17985772d431	2ef5fd75-6752-4e6b-ba59-02d2761e999e	{"Possessed Monster Island Tech"}	20
7be35dd2-8758-4cb8-85af-17985772d431	fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	{"Moon Base Commander Nishikawa"}	6
7f9c68a7-8cec-4f4e-be97-528fe66605c3	505a2aab-1965-4e16-a6b4-697e14d85d1a	{"Fishing Company Employee"}	99
\.


--
-- Data for Name: film_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY film_images (film_id, type, file_name, caption) FROM stdin;
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00052	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00501	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01075	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01863	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02397	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00110	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	01062	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	02490	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	00067	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	01070	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02668	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	00054	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	01522	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	00144	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	01463	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	02491	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	00191	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01157	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01831	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02635	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00158	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00976	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01768	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	00069	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01111	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01974	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02386	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00049	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00903	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01810	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02622	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00087	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00419	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00665	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01157	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01527	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01982	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02674	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	00029	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	01660	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00096	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01035	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01608	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02123	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00080	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00904	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01761	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	02073	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00020	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00528	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01360	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02236	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	00076	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	01288	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02344	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00059	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00773	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01350	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02147	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	00121	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01323	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	02493	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	00191	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	01498	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02411	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	03229	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00113	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00807	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01817	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	02966	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	00043	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	01580	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02505	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00075	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00985	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02395	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00130	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00613	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	01874	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02678	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00130	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00813	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	02130	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	00140	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	02083	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	00067	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	01413	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	02709	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00228	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	01266	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02182	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02634	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00056	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00868	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	01964	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02504	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00083	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	01115	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	02417	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00125	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00544	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01093	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	02290	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	04202	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00076	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00517	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01260	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01899	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02421	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00378	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	01172	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	02543	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	00196	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	01097	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02691	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	00255	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	01572	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	00308	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	01565	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	02514	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	00221	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01164	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02012	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02656	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00160	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01073	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01778	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	00194	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01299	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02005	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02421	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00208	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00987	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01825	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02649	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00097	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00430	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00686	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01186	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01532	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02036	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02745	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	00067	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	01672	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00165	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01093	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01762	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02151	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00142	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00982	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01778	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00093	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00731	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01420	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02287	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	00135	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	01348	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02406	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00108	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00812	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01367	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02178	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	00296	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01361	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	02548	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	00267	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	01553	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02467	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	03275	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00207	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00824	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01821	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	03001	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	00209	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	01717	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02517	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00228	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	01231	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02467	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00188	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00641	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02143	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02762	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00161	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00823	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	02324	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	00181	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	02221	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	00245	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	01518	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	02719	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00257	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	01269	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02230	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02646	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00213	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00929	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	01985	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02563	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00231	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	01160	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	02784	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00143	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00660	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01101	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	02647	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	04322	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00151	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00554	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01301	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01952	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02596	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00419	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	01351	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	00267	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	01172	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02726	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	00347	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	02212	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	00443	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	01605	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	02525	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	00293	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01193	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02051	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02697	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00173	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01092	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01785	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	00215	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01373	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02016	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02430	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00542	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01009	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02236	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02676	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00204	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00468	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00702	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01207	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01654	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02085	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02752	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	00182	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	01765	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00223	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01117	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01817	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02154	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00166	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01158	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01827	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00113	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00780	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01479	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02370	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	00180	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	01391	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02441	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00126	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00914	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01387	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02191	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	00392	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01387	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	02627	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	00509	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	01841	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02762	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00246	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01027	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	02129	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	00376	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	01873	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02550	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00245	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	01243	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02616	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00212	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00736	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02179	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02777	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00333	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00978	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	02528	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	00367	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	02358	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	00314	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	01713	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00320	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	01510	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02247	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00252	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00934	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02154	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02591	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00243	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	01394	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	02823	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00149	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00739	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01258	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	02793	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	04808	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00164	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00563	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01315	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01964	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02613	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00581	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	01544	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	00273	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	01239	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02752	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	00571	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	02255	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	00475	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	01628	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	02535	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	00336	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01291	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02069	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02783	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00517	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01200	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01997	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	00331	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01413	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02150	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00554	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01207	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02249	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02746	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00230	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00510	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00734	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01259	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01667	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02097	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02785	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	00464	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	01998	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00243	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01194	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01864	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02204	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00178	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01185	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01842	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00123	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00945	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01616	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02474	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	00328	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	01450	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02493	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00242	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00930	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01425	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02284	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	00586	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01566	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	00690	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	01869	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02884	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00288	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01105	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	02391	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	00473	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02037	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02559	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00357	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	01432	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02643	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00282	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00906	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02312	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02791	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00422	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	01047	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	02558	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	00413	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	00844	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	01772	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00452	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	01526	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02263	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00334	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	01089	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02168	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00287	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	01443	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	02978	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00224	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00848	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01326	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	02997	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	04898	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00250	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00583	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01476	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02149	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02623	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00679	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	01711	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	00521	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	01500	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02755	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	00598	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	02321	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	00678	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	01656	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	00592	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01326	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02270	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00616	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01214	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	02080	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	00417	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01547	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02170	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00568	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01393	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02392	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02755	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00250	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00522	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00879	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01380	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01682	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02142	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02811	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	00591	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	02034	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00486	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01251	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01901	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02279	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00205	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01327	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01861	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00188	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01061	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01630	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02600	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	00489	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	01801	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02516	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00280	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01042	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01480	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02306	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	00790	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01669	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	00773	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	01972	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02941	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00426	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01107	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	02463	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	00662	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02263	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02607	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00593	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	01568	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02714	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00365	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	01095	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02371	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02867	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00440	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	01228	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	02677	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	00673	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	00923	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	01854	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00628	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	01726	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02292	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00414	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	01124	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02226	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00403	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	01543	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00330	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00853	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01542	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	03115	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	05017	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00290	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00617	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01494	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02203	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02662	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00846	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	01765	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	00695	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	01722	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02777	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	00701	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	02475	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	00751	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	01740	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	00661	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01442	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02411	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00658	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01263	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	02189	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	00537	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01663	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02242	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00581	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01444	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02403	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02758	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00265	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00543	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00898	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01407	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01693	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02175	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02830	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	00829	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	02143	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00543	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01343	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01999	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02316	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00350	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01409	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01888	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00210	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01109	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01669	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02624	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	00584	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	01858	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02580	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00298	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01052	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01522	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02307	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	00936	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01814	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	00800	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02072	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02973	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00495	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01146	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	02718	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	00851	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02325	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02633	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00621	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	01618	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02825	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00397	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	01126	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02459	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	03008	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00490	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	01427	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	02743	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	00698	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	00996	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	02075	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00739	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	01757	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02353	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00437	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	01170	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02228	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00522	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	01700	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00351	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00924	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01667	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	03253	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	05151	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00357	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00639	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01514	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02272	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02713	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00886	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	01773	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	00705	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02039	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	00792	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	02582	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	00759	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	01852	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	00904	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01462	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02494	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00664	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01329	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	02363	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	00782	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01680	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02300	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00585	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01449	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02451	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00340	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00561	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00946	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01412	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01696	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02463	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02884	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	01129	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	02215	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00649	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01363	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02026	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02367	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00375	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01413	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01953	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00212	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01114	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01824	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02627	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	00742	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02029	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02631	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00415	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01074	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01638	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02343	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01092	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01820	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	00843	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02094	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	03005	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00553	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01202	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	02724	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	00868	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02353	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02696	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00626	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	01912	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02856	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00418	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	01184	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02482	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	03114	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00534	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	01489	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	02828	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	00719	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	01020	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	02184	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00750	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	01977	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02471	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00556	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	01357	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02264	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00636	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	01738	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00385	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00939	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01824	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	03464	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	05193	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00415	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00758	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01585	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02321	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02760	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00913	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	02197	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	00778	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02168	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	00851	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	00885	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	01988	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01043	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01484	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02530	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00755	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01331	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	02455	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	00879	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01900	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02331	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00624	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01541	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02551	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00347	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00577	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00956	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01441	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01719	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02507	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	01417	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	02223	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00796	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01389	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02044	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02422	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00449	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01614	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01986	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00350	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01165	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01966	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02647	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	00917	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02160	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02666	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00497	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01087	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01789	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02354	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01237	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	02036	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	01110	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02218	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	03039	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00586	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01394	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	02867	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	01045	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02394	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00655	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02287	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02874	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00453	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	01233	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02556	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00626	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	01734	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	02874	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	01052	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	01233	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	02281	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00827	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	01995	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02486	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00564	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	01562	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02280	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00739	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	01864	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00427	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00976	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01971	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	03627	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	05262	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00437	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00839	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01598	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02327	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00951	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	02446	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	00838	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02284	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	00881	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	00933	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	02332	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01093	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01621	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02547	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00785	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01566	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	02545	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	00912	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01928	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02367	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00684	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01547	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02561	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00383	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00625	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00983	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01443	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01828	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02590	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	01589	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	02256	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00887	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01455	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02050	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02525	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00540	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01622	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	02032	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00431	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01349	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02039	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02653	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	00978	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02188	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00615	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01106	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01928	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02390	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01253	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	02354	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	01218	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02239	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	03080	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00641	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01602	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	02902	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	01116	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02445	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00788	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02383	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02888	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00484	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	01552	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02584	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00793	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	01827	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	01412	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	01247	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	02578	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00886	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02111	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02556	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00625	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	01616	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02411	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00844	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	02113	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00482	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01008	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	02140	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	03904	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	05376	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	00456	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01063	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	01737	\N
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	gallery	02335	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	00967	\N
132ec70b-0248-450e-9ae2-38c8245dc2e9	gallery	02476	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	01032	\N
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	gallery	02620	\N
23c1c82e-aedb-4c9b-b040-c780eec577e8	gallery	01335	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	01054	\N
249785ea-a53b-43e3-94d6-c5d2f2d833c4	gallery	02437	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01136	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	01797	\N
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	gallery	02583	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	00960	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	01689	\N
40cb6fad-15b4-46f5-8066-273cb965c3c4	gallery	02561	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01001	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	01950	\N
56dab76c-fc4d-4547-b2fe-3a743154f1d5	gallery	02380	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	00886	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	01629	\N
5df297a2-5f6d-430d-b7fc-952e97ac9d79	gallery	02618	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00404	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	00646	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01086	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01483	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	01956	\N
653335e2-101e-4303-90a2-eb71dac3c6e3	gallery	02623	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	01636	\N
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	gallery	02395	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	00989	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	01514	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02063	\N
75bb901c-e41c-494f-aae8-7a5282f3bf96	gallery	02614	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	00603	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	01671	\N
79a16ff9-c72a-4dd0-ba4e-67f578e97682	gallery	02040	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	00432	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	01355	\N
7be35dd2-8758-4cb8-85af-17985772d431	gallery	02099	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	01199	\N
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	gallery	02278	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	00703	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01139	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	01991	\N
7f9c68a7-8cec-4f4e-be97-528fe66605c3	gallery	02402	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	01296	\N
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	gallery	02422	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	01316	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	02304	\N
9b724e83-39e6-4e57-b112-81e74d578ae0	gallery	03089	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	00774	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	01716	\N
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	gallery	02946	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	01525	\N
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	gallery	02460	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	00840	\N
b30c5657-a980-489b-bd91-d58e63609102	gallery	02386	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	00587	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	01663	\N
ba6031ef-c7b0-451c-8465-cb2a3c494896	gallery	02648	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	00805	\N
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	gallery	01931	\N
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	gallery	01600	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	01351	\N
e8ccb201-e076-48cb-9307-f8b99101f133	gallery	02685	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	00967	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02142	\N
ef4f2354-b764-4f5e-af66-813369a2520c	gallery	02626	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	00751	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	01935	\N
f474852a-cc25-477d-a7b9-06aa688f7fb2	gallery	02437	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	00891	\N
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	gallery	02153	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	00514	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	01075	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	02216	\N
0a158e9d-6e48-4b6e-9674-862d952fb3ab	gallery	04186	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	00059	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	00099	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	00189	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	00458	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	00693	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	00745	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	00817	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	00891	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	00908	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	01009	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	01284	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	01431	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	01508	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02029	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02178	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02220	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02254	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02380	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02399	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02488	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02507	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02533	\N
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	gallery	02586	\N
\.


--
-- Data for Name: films; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY films (id, title, release_date, duration, showcase, aliases, props) FROM stdin;
653335e2-101e-4303-90a2-eb71dac3c6e3	Godzilla, King of the Monsters	1954-11-03	97	t	{Godzilla}	{"original_title": "&#12468;&#12472;&#12521;", "original_translation": "Godzilla", "original_transliteration": "Gojira"}
7f9c68a7-8cec-4f4e-be97-528fe66605c3	Godzilla Raids Again	1955-04-24	82	t	{"Gigantis, the Fire Monster"}	{"original_title": "&#12468;&#12472;&#12521;&#12398;&#36870;&#35186;", "original_translation": "Counterattack of Godzilla", "original_transliteration": "Gojira No Gyakushyuu"}
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	King Kong vs. Godzilla	1962-08-11	97	t	\N	{"original_title": "&#12461;&#12531;&#12464;&#12467;&#12531;&#12464;&#23550;&#12468;&#12472;&#12521;", "original_translation": "King Kong Against Godzilla", "original_transliteration": "Kingukongu Tai Gojira"}
75bb901c-e41c-494f-aae8-7a5282f3bf96	Mothra vs. Godzilla	1964-04-29	89	t	{"Godzilla vs. the Thing"}	{"original_title": "&#12514;&#12473;&#12521;&#23550;&#12468;&#12472;&#12521;", "original_translation": "Mothra Against Godzilla", "original_transliteration": "Mosura Tai Gojira"}
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	Ghidorah, the Three-Headed Monster	1964-12-20	93	t	{"Ghidrah, the Three-Headed Monster"}	{"original_title": "&#19977;&#22823;&#24618;&#29539; &#22320;&#29699;&#26368;&#22823;&#12398;&#27770;&#25126;", "original_translation": "Three Giant Monsters Greatest Battle of Earth", "original_transliteration": "San Daikaijyuu Chikyuu Saidai No Kessen"}
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	Monster Zero	1965-12-19	94	t	{"Godzilla vs. Monster Zero","Invasion of Astro-Monster"}	{"original_title": "&#24618;&#29539;&#22823;&#25126;&#20105;", "original_translation": "Monster Great War", "original_transliteration": "Kaijyuu Daisensou"}
40cb6fad-15b4-46f5-8066-273cb965c3c4	Son of Godzilla	1967-12-16	86	t	\N	{"original_title": "&#24618;&#29539;&#23798;&#12398;&#27770;&#25126; &#12468;&#12472;&#12521;&#12398;&#24687;&#23376;", "original_translation": "Battle of Monster Island Son of Godzilla", "original_transliteration": "Kaijyuutou No Kessen Gojira No Musuko"}
7be35dd2-8758-4cb8-85af-17985772d431	Destroy All Monsters	1968-08-01	89	t	\N	{"original_title": "&#24618;&#29539;&#32207;&#36914;&#25731;", "original_translation": "Monster Marching Attack", "original_transliteration": "Kaijyuu Soushingeki"}
79a16ff9-c72a-4dd0-ba4e-67f578e97682	The Invisible Man	1954-12-29	70	t	\N	{"original_title": "&#36879;&#26126;&#20154;&#38291;", "original_translation": "Invisible Man", "original_transliteration": "Toumei Ningen"}
ef4f2354-b764-4f5e-af66-813369a2520c	The Mysterians	1957-12-28	88	t	\N	{"original_title": "&#22320;&#29699;&#38450;&#34907;&#36557;", "original_translation": "Earth Defense Force", "original_transliteration": "Chikyuu Boueigun"}
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	Varan the Unbelievable	1958-10-14	82	t	\N	{"original_title": "&#22823;&#24618;&#29539;&#12496;&#12521;&#12531;", "original_translation": "Giant Monster Varan", "original_transliteration": "Daikaijyuu Baran"}
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	Battle in Outer Space	1959-12-26	91	t	\N	{"original_title": "&#23431;&#23449;&#22823;&#25126;&#20105;", "original_translation": "Space Great War", "original_transliteration": "Uchyuu Daisensou"}
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	Mothra	1961-07-30	101	t	\N	{"original_title": "&#12514;&#12473;&#12521;", "original_translation": "Mothra", "original_transliteration": "Mosura"}
9b724e83-39e6-4e57-b112-81e74d578ae0	The Last War	1961-10-08	110	t	\N	{"original_title": "&#19990;&#30028;&#22823;&#25126;&#20105;", "original_translation": "World Great War", "original_transliteration": "Sekai Daisensou"}
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	Matango	1963-08-11	89	t	{"Attack of the Mushroom People"}	{"original_title": "&#12510;&#12479;&#12531;&#12468;", "original_translation": "Matango", "original_transliteration": "Matango"}
5df297a2-5f6d-430d-b7fc-952e97ac9d79	Atragon	1963-12-22	94	t	\N	{"original_title": "&#28023;&#24213;&#36557;&#33382;", "original_translation": "Undersea Warship", "original_transliteration": "Kaitei Gunkan"}
f474852a-cc25-477d-a7b9-06aa688f7fb2	Godzilla vs. the Sea Monster	1966-12-17	87	t	{"Ebirah, Horror of the Deep"}	{"original_title": "ゴジラ・エビラ・モスラ 南海の大決闘", "original_translation": "Godzilla Ebirah Mothra South Seas Great Duel", "original_transliteration": "Gojira Ebira Mosura Nankai No Daikettou"}
ba6031ef-c7b0-451c-8465-cb2a3c494896	King Kong Escapes	1967-07-22	104	t	\N	{"original_title": "&#12461;&#12531;&#12464;&#12467;&#12531;&#12464;&#12398;&#36870;&#35186;", "original_translation": "Counterattack of King Kong", "original_transliteration": "Kingukongu No Gyakushyuu"}
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	The Adventures of Taklamakan	1966-04-28	100	t	{"Adventure at Kiganjoh"}	{"original_title": "&#22855;&#24012;&#22478;&#12398;&#20882;&#38522;", "original_translation": "Adventure of Stone Castle", "original_transliteration": "Kiganjyou No Bouken"}
56dab76c-fc4d-4547-b2fe-3a743154f1d5	Rodan	1956-12-26	82	t	\N	{"original_title": "&#31354;&#12398;&#22823;&#24618;&#29539;&#12521;&#12489;&#12531;", "original_translation": "Giant Monster of Sky Rodan", "original_transliteration": "Sora no Daikaijyuu Radon"}
132ec70b-0248-450e-9ae2-38c8245dc2e9	The H-Man	1958-06-24	87	t	\N	{"original_title": "&#32654;&#22899;&#12392;&#28082;&#20307;&#20154;&#38291;", "original_translation": "Beauty and Liquid Man", "original_transliteration": "Bijyo To Ekitainingen"}
0a158e9d-6e48-4b6e-9674-862d952fb3ab	The Birth of Japan	1959-10-25	182	t	{"The Three Treasures"}	{"original_title": "&#26085;&#26412;&#35477;&#29983;", "original_translation": "Birth of Japan", "original_transliteration": "Nihon Tanjyou"}
249785ea-a53b-43e3-94d6-c5d2f2d833c4	The Secret of the Telegian	1960-04-10	85	t	\N	{"original_title": "&#38651;&#36865;&#20154;&#38291;", "original_translation": "Electric Man", "original_transliteration": "Densou Ningen"}
e8ccb201-e076-48cb-9307-f8b99101f133	The Human Vapor	1960-12-11	91	t	\N	{"original_title": "&#12460;&#12473;&#20154;&#38291;&#31532;&#19968;&#21495;", "original_translation": "Gas Man No. 1", "original_transliteration": "Gasu Ningen Dai Ichigou"}
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	Gorath	1962-03-21	88	t	\N	{"original_title": "&#22934;&#26143;&#12468;&#12521;&#12473;", "original_translation": "Mystery Planet Gorath", "original_transliteration": "Yousei Gorasu"}
b30c5657-a980-489b-bd91-d58e63609102	Samurai Pirate	1963-10-26	97	t	{"The Lost World of Sinbad"}	{"original_title": "&#22823;&#30423;&#36042;", "original_translation": "Great Bandit", "original_transliteration": "Daitouzoku"}
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	Dogora, the Space Monster	1964-08-11	81	t	{Dogora}	{"original_title": "&#23431;&#23449;&#22823;&#24618;&#29539;&#12489;&#12468;&#12521;", "original_translation": "Space Giant Monster Dogora", "original_transliteration": "Uchyuu Daikaijyuu Dogora"}
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	Frankenstein Conquers the World	1965-08-08	94	t	{"Frankenstein vs. Baragon"}	{"original_title": "&#12501;&#12521;&#12531;&#12465;&#12531;&#12471;&#12517;&#12479;&#12452;&#12531;&#23550;&#22320;&#24213;&#24618;&#29539;&#12496;&#12521;&#12468;&#12531;", "original_translation": "Frankenstein Against Underground Monster Baragon", "original_transliteration": "Furankenshyutain Tai Chitei Kaijyuu Baragon"}
58c94670-94fc-43fb-b42b-30ed9a306ae8	Gantz	2011-01-29	130	f	\N	{"original_title": "ガンツ", "original_translation": "Gantz", "original_transliteration": "Gantsu"}
23c1c82e-aedb-4c9b-b040-c780eec577e8	War of the Gargantuas	1966-07-31	88	t	\N	{"original_title": "&#12501;&#12521;&#12531;&#12465;&#12531;&#12471;&#12517;&#12479;&#12452;&#12531;&#12398;&#24618;&#29539; &#12469;&#12531;&#12480;&#23550;&#12460;&#12452;&#12521;", "original_translation": "Monsters of Frankenstein Sanda Against Gaira", "original_transliteration": "Furankenshyutain no Kaijyuu Sanda Tai Gaira"}
44c5daba-56db-4918-9e92-3f673631b3b9	The Hidden Fortress	1958-12-28	139	f	\N	{"original_title": "隠し砦の三悪人", "original_translation": "Three Villains of the Hidden Fortress", "original_transliteration": "Kakushi Toride No San Akunin"}
91f3996c-85e9-49f6-8cea-c3dd3ac4c2e2	Yojimbo	1961-04-25	110	f	\N	{"original_title": "用心棒", "original_translation": "Bodyguard", "original_transliteration": "Youjinbou"}
1e30aa89-d04e-4742-8283-a57bc37fdb8d	Sanjuro	1962-01-01	96	f	\N	{"original_title": "椿三十郎", "original_translation": "Thirty-Year-Old Camellia", "original_transliteration": "Tsubaki Sanjyuurou"}
db1ac1c3-fc1d-418d-b44b-fb82cbde802c	High and Low	1963-03-01	143	f	\N	{"original_title": "天国と地獄", "original_translation": "Heaven and Hell", "original_transliteration": "Tengoku To Jigoku"}
8673b73b-ffce-464d-8673-c8ca60b10cf8	Three Outlaw Samurai	1964-05-13	94	f	\N	{"original_title": "三匹の侍", "original_translation": "Three Samurai", "original_transliteration": "Sanbiki No Samurai"}
ea195732-907d-4586-b446-608e919f2599	Gamera vs. Guiron	1969-03-21	82	f	{"Attack of the Monsters"}	{"original_title": "ガメラ対大悪獣ギロン", "original_translation": "Gamera Against Great Villain Beast Guiron", "original_transliteration": "Gamera Tai Daiakujyuu Giron"}
f3bbb9b5-4893-4e50-a6e0-7a25f1b8d618	Gamera vs. Jiger	1970-03-21	83	f	{"Gamera vs. Monster X"}	{"original_title": "ガメラ対大魔獣ジャイガー", "original_translation": "Gamera Against Great Demon Beast Jiger", "original_transliteration": "Gamera Tai Daimajyuu Jyaigaa"}
802edf4f-2899-4309-a7ac-a1166137e903	Gamera vs. Zigra	1971-07-17	88	f	\N	{"original_title": "ガメラ対深海怪獣ジグラ", "original_translation": "Gamera Against Deep Sea Monster Zigra", "original_transliteration": "Gamera Tai Shinkai Kaijyuu Jigura"}
7392a4a7-9894-462c-97f2-7a929ea2ce00	Latitude Zero	1969-07-26	105	f	\N	{"original_title": "緯度0大作戦", "original_translation": "Latitude Zero Great Strategy", "original_transliteration": "Ido Zero Daisakusen"}
42255770-e43c-473d-81ca-f412b6f78c62	Godzilla's Revenge	1969-12-20	70	f	{"All Monsters Attack"}	{"original_title": "ゴジラ・ミニラ・ガバラ オール怪獣大進撃", "original_translation": "Godzilla Minya Gabara All Monsters Big Attack", "original_transliteration": "Gojira Minira Gabara Ooru Kaijyuu Daishingeki"}
a477ef60-d6ae-4406-9914-2a7e060ac379	Legend of the Eight Samurai	1983-12-10	136	f	\N	{"original_title": "里見八犬伝", "original_translation": "Legend of Satomi's Eight Dogs", "original_transliteration": "Satomi Hakken Den"}
361e3cdb-8f40-4a21-974a-3e792abe9e4a	Stray Dog: Kerberos Panzer Cops	1991-03-23	99	f	\N	{"original_title": "ケルベロス-地獄の番犬", "original_translation": "Kerberos - Guard Dog of Hell", "original_transliteration": "Keruberosu - Jigoku no Banken"}
ce555690-494d-4983-a2a7-c99fb2fc0387	Daimajin Strikes Again	1966-12-10	87	t	{"The Return of Daimajin"}	{"original_title": "大魔神逆襲", "original_translation": "Great Demon Counterattack", "original_transliteration": "Daimajin Gyakushyuu"}
0704c7e5-5709-4401-adaa-8cbec670e47d	Gamera, the Giant Monster	1965-11-27	78	t	{"Gammera the Invincible",Gamera}	{"original_title": "大怪獣ガメラ", "original_translation": "Giant Monster Gamera", "original_transliteration": "Daikaijyuu Gamera"}
16789ef4-c05d-4f15-b09f-3bed5291655c	Gamera vs. Barugon	1966-04-17	101	t	{"War of the Monsters"}	{"original_title": "大怪獣決闘 ガメラ対バルゴン", "original_translation": "Giant Monster Battle Gamera Against Barugon", "original_transliteration": "Daikaijyuu Kessen Gamera Tai Barugon"}
40ca591f-8493-4fad-9527-464e3501e1d2	Gamera vs. Gyaos	1967-03-15	87	t	{"Gamera vs. Gaos","The Return of the Giant Monsters"}	{"original_title": "大怪獣空中戦 ガメラ対ギャオス", "original_translation": "Giant Monster Air Battle Gamera Against Gyaos", "original_transliteration": "Daikaijyuu Kuuchyuusen Gamera Tai Gyaosu"}
bbfd5e01-14bc-4890-aab1-92a02bec413d	Gamera vs. Viras	1968-03-20	72	t	{"Destroy All Planets"}	{"original_title": "ガメラ対宇宙怪獣バイラス", "original_translation": "Gamera Against Space Monster Viras", "original_transliteration": "Gamera Tai Uchyuu Kaijyuu Bairasu"}
89faa565-3c41-4d2d-b589-df8b13007a5e	The Golden Bat	1966-12-21	73	t	\N	{"original_title": "黄金 バット", "original_translation": "Golden Bat", "original_transliteration": "Ougon Batto"}
f47487ec-0730-46ae-9056-29fe675715b0	The Magic Serpent	1966-12-21	94	t	\N	{"original_title": "怪竜大決戦", "original_translation": "Dragon Great Battle", "original_transliteration": "Kairyuu Daikessen"}
a50d9661-fed2-455d-9a9a-009ffa254b07	The X from Outer Space	1967-03-25	88	t	\N	{"original_title": "宇宙大怪獣ギララ", "original_translation": "Giant Space Monster Guirara", "original_transliteration": "Uchuu Daikaijyuu Girara"}
ef01babe-d621-40ca-8d85-363b051921a6	Genocide	1968-11-09	84	t	\N	{"original_title": "昆虫大戦争", "original_translation": "Insect Great War", "original_transliteration": "Konchyuu Daisensou"}
0b006dae-79e5-4dca-b8e2-09591eacba55	Goke, Body Snatcher from Hell	1968-08-14	84	t	\N	{"original_title": "吸血鬼ゴケミドロ", "original_translation": "Vampire Gokemidoro", "original_transliteration": "Kyuuketsuki Gokemidoro"}
9883d93a-db06-4c02-ba91-1d41c335acf1	Rashomon	1950-08-26	88	t	\N	{"original_title": "羅生門", "original_translation": "Rashomon", "original_transliteration": "Rashyoumon"}
14fab775-bb0f-413e-9840-be528e07ba70	Samurai I: Musashi Miyamoto	1954-09-26	94	t	\N	{"original_title": "宮本武蔵", "original_translation": "Miyamoto Musashi", "original_transliteration": "Miyamoto Musashi"}
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	Seven Samurai	1954-04-26	207	t	\N	{"original_title": "七人の侍", "original_translation": "Seven Samurai", "original_transliteration": "Shichinin No Samurai"}
0541315f-20ef-4562-95a5-8c4f45199d63	Throne of Blood	1957-01-15	110	t	\N	{"original_title": "蜘蛛巣城", "original_translation": "Spider Web Castle", "original_transliteration": "Kumonosujyou"}
e74d0fad-f701-4540-b48e-9e73e2062b0b	Godzilla vs. the Cosmic Monster	1974-03-21	84	f	{"Godzilla vs. the Bionic Monster","Godzilla vs. Mechagodzilla"}	{"original_title": "ゴジラ対メカゴジラ", "original_translation": "Godzilla Against Mechagodzilla", "original_transliteration": "Gojira Tai Mekagojira"}
e1f6af59-f60e-4213-b722-1d0f987da1f8	Kagemusha	1980-04-26	179	f	\N	{"original_title": "影武者", "original_translation": "Shadow Warrior", "original_transliteration": "Kagemushya"}
bce2da2a-8823-4d3d-b49e-90c65452f719	Godzilla VS Biollante	1989-12-16	105	f	\N	{"original_title": "ゴジラvsビオランテ", "original_translation": "Godzilla VS Biollante", "original_transliteration": "Gojira VS Biorante"}
cb8d5a73-7c9c-4093-878d-4eb6c074c7b3	Zeiram 2	1994-12-17	100	f	\N	{"original_title": "ゼイラム2", "original_translation": "Zeiram 2", "original_transliteration": "Zeiramu 2"}
bdd71ef3-19fb-49dd-a66f-d0742185846c	Gamera 3: Revenge of Iris	1999-03-06	108	f	{"Gamera 3: The Demon Awakes"}	{"original_title": "ガメラ3 邪神〈イリス〉覚醒", "original_translation": "Gamera 3: Evil Spirit (Iris) Awakens", "original_transliteration": "Gamera 3 Jyashin (Irisu) Kakusei"}
fcb4b537-1a27-42e2-bafb-2f23564f033a	Ring 2	1999-01-23	95	f	\N	{"original_title": "リング2", "original_translation": "Ring 2", "original_transliteration": "Ringu 2"}
cd384f7c-2a1a-473c-8ecf-867ab9bacc5a	Godzilla X Mechagodzilla	2002-12-14	88	f	\N	{"original_title": "ゴジラ×メカゴジラ", "original_translation": "Godzilla X Mechagodzilla", "original_transliteration": "Gojira X Mekagojira"}
b45d956a-595b-4980-8d3f-7ddd7063e283	Azumi 2: Death or Love	2005-03-12	112	f	\N	{"original_title": "あずみ2 Death or Love", "original_translation": "Azumi 2 Death or Love", "original_transliteration": "Azumi 2 Death or Love"}
234560f2-ada9-40e4-8f50-701f701dec82	The Eternal Zero	2013-12-21	144	f	\N	{"original_title": "永遠の0", "original_translation": "Eternal Zero", "original_transliteration": "Eien No Zero"}
060ee386-1a7f-4e91-bb93-f7c6f249f71b	Gantz: Perfect Answer	2011-04-23	141	f	\N	{"original_title": "ガンツ・パーフェクトアンサー", "original_translation": "Gants: Perfect Answer", "original_transliteration": "Gantsu Paafekuto Ansaa"}
e41cf916-5691-4a46-8cb6-e70f4d185b58	One Missed Call 2	2005-02-05	106	f	\N	{"original_title": "着信アリ2", "original_translation": "Incoming Call 2", "original_transliteration": "Chyakushin Ari 2"}
91b3b4e9-f72e-4c60-a50f-1829fdb2940f	Lorelei	2005-03-05	128	f	{"Lorelei: The Witch of the Pacific Ocean"}	{"original_title": "ローレライ", "original_translation": "Lorelei", "original_transliteration": "Roorerai"}
a229e05d-ee47-46ec-9e2b-6410b7ddf4e9	Lupin the Third	2014-08-30	133	f	\N	{"original_title": "ルパン三世", "original_translation": "Lupin the Third", "original_transliteration": "Rupan Sansei"}
5088aef6-3dcc-4fda-af9e-6777becd1285	13 Assassins	2010-09-25	141	f	\N	{"original_title": "十三人の刺客", "original_translation": "Thirteen Assassins", "original_transliteration": "Jyuusannin No Shikaku"}
a44dcca3-ca55-4ca7-b7c4-f095367de638	The Triumphant General Rouge	2009-03-07	123	f	\N	{"original_title": "ジェネラル・ルージュの凱旋", "original_translation": "Triumph of General Rouge", "original_transliteration": "Jyeneraru Ruujyu No Gaisen"}
e7741ae5-bed4-46d9-8ca2-aeac4accf28c	Space Amoeba	1970-08-01	84	f	{"Yog, Monster from Space"}	{"original_title": "ゲゾラ・ガニメ・カメーバ 決戦!南海の大怪獣", "original_translation": "Gezora Ganime Kamoeba Battle! South Seas Giant Monsters", "original_transliteration": "Gezora Ganime Kameeba Kessen! Nankai No Daikaijyuu"}
3b7381aa-ff9a-4b2e-806a-1c6b700614ae	The Submersion of Japan	1973-12-29	140	f	{"Tidal Wave"}	{"original_title": "日本沈没", "original_translation": "Japan Sunk", "original_transliteration": "Nippon Chinbotsu"}
6a3a47b5-cc33-4a7d-8bac-b2aaf023b403	Gamera, the Space Monster	1980-03-20	109	f	{"Super Monster Gamera"}	{"original_title": "宇宙怪獣ガメラ", "original_translation": "Space Monster Gamera", "original_transliteration": "Uchyuu Kaijyuu Gamera"}
5fe8aa5c-cb71-478b-b261-657bc3fcff64	Gunhed	1989-07-22	100	f	\N	{"original_title": "ガンヘッド", "original_translation": "Gunhed", "original_transliteration": "Ganheddo"}
0551ee7d-fecc-4851-a083-f75c65daf18a	Yamato Takeru	1994-07-09	103	f	{"Orochi, the Eight-Headed Dragon"}	{"original_title": "ヤマトタケル", "original_translation": "The Strength of Yamato", "original_transliteration": "Yamato Takeru"}
99365581-abc2-48b0-bbb5-61a081c8c709	Makai Tensho: Samurai Armageddon	1996-04-26	85	f	{"Reborn from Hell: Samurai Armageddon"}	{"original_title": "魔界転生", "original_translation": "Demon World Incarnation", "original_transliteration": "Makai Tenshyou"}
a39991bd-6f9b-449f-a011-359411ffbfa1	Tomie	1999-03-06	95	f	\N	{"original_title": "富江", "original_translation": "Tomie", "original_transliteration": "Tomie"}
c40ae945-d13c-4778-a0a6-6d78b94966ae	Godzilla: Final Wars	2004-12-04	125	f	\N	{"original_title": "ゴジラ ファイナル ウォーズ", "original_translation": "Godzilla: Final Wars", "original_transliteration": "Gojira Fainaru Uoozu"}
0a4a2822-7bca-4000-96c6-268000432e56	Juvenile	2000-07-15	105	f	\N	{"original_title": "ジュブナイル Boys Meet the Future", "original_translation": "Juvenile: Boys Meet the Future", "original_transliteration": "Jyubunairu Boys Meet the Future"}
91d16b63-9716-4725-b319-b9ff46c80487	Parasyte	2014-11-29	109	f	\N	{"original_title": "寄生獣", "original_translation": "Parasitic Beast", "original_transliteration": "Kiseijyuu"}
c287b984-0a4b-406f-a9a7-c21023ecd189	Oblivion Island: Haruka and the Magic Mirror	2009-08-22	93	f	\N	{"original_title": "ホッタラケの島 〜遥と魔法の鏡〜", "original_translation": "Hottarake Island: Haruka and the Magic Mirror", "original_transliteration": "Hottarake No Shima Haruka To Mahou No Kagame"}
010090c2-b952-4ae7-8dc0-15b2ecc0dce6	Battlefield Baseball	2002-07-19	87	f	\N	{"original_title": "地獄甲子園", "original_translation": "Hell Stadium", "original_transliteration": "Jigoku Koushien"}
80239011-e3d9-4de4-9e9e-fb0733260577	Hidden Fortress: The Last Princess	2008-05-10	118	f	\N	{"original_title": "隠し砦の三悪人 THE LAST PRINCESS", "original_translation": "Three Villains of the Hidden Fortress: The Last Princess", "original_transliteration": "Kakushi Toride No San Akunin The Last Princess"}
ac185eaf-3ac8-4d1b-b886-2648b8fb3cb6	Death Note	2006-06-17	126	f	\N	{"original_title": "デスノート", "original_translation": "Death Note", "original_transliteration": "Desu Nooto"}
242c97f0-edcc-4857-8211-bb130160275e	Tsubaki Sanjuro	2007-12-01	119	f	\N	{"original_title": "椿三十郎", "original_translation": "Thirty-Year-Old Camellia", "original_transliteration": "Tsubaki Sanjyuurou"}
88a761bb-acae-4a56-b157-ed2fe51951ab	Kaiji 2	2011-11-05	133	f	\N	{"original_title": "カイジ2", "original_translation": "Kaiji 2", "original_transliteration": "Kaiji 2"}
092d908c-750c-4c66-9d34-5c0b69089b6c	Vampire Doll	1970-07-04	71	f	\N	{"original_title": "幽霊屋敷の恐怖 血を吸う人形", "original_translation": "Horror of Haunted House: Bloodsucking Doll", "original_transliteration": "Yuureiyashiki No Kyoufu Chiwosuu Ningyou"}
9a752a5a-d621-40dc-a992-3f9dcf56d6b9	Espy	1974-12-28	94	f	\N	{"original_title": "エスパイ", "original_translation": "Espy", "original_transliteration": "Esupai"}
c03741eb-2f51-411e-937c-5b1ce71efb6b	One Missed Call	2003-11-03	112	f	\N	{"original_title": "着信アリ", "original_translation": "Incoming Call", "original_transliteration": "Chyakushin Ari"}
0c039e43-df7f-4bf0-83f1-e7717611bf73	Mechanical Violator Hakaider	1995-04-15	52	f	\N	{"original_title": "人造人間ハカイダー", "original_translation": "Android Hakaider", "original_transliteration": "Shinzou Ningen Hakaidaa"}
ae7919c4-fa6b-403c-91b2-a75e01d747b1	Moon Over Tao	1997-11-29	96	f	\N	{"original_title": "タオの月", "original_translation": "Moon of Tao", "original_transliteration": "Tao No Tsuki"}
e0a5b9ea-6ba6-4af6-85e3-92688ab6343f	Gojoe	2000-10-07	137	f	\N	{"original_title": "五条霊戦記", "original_translation": "Gojo Spiritual War Record", "original_transliteration": "Gojyoureisenki"}
4f663866-4a44-4560-bd28-58446fbd15a0	Returner	2002-08-31	116	f	\N	{"original_title": "リターナー", "original_translation": "Returner", "original_transliteration": "Retaanaa"}
aa1b31c9-1fed-4e90-a0bf-2b0f12f9ef75	Parasyte: Completion	2015-04-25	117	f	\N	{"original_title": "寄生獣 完結編", "original_translation": "Parasitic Beast Completion", "original_transliteration": "Kiseijyuu Kanketsuhen"}
dd83f9ef-cece-4825-b1ed-f63063b0226b	Onmyoji	2001-10-06	116	f	\N	{"original_title": "陰陽師", "original_translation": "Yin Yang Master", "original_transliteration": "Onmyouji"}
e2a0f019-2668-4657-a1a0-02fc7fb5c188	Masked Rider: The First	2005-11-05	90	f	\N	{"original_title": "仮面ライダー THE FIRST", "original_translation": "Masked Rider: The First", "original_transliteration": "Kamen Raidaa The First"}
a30b441a-bdc6-4b6c-b947-43f9e509b2bd	Death Note: The Last Name	2006-11-03	140	f	\N	{"original_title": "デスノート the Last name", "original_translation": "Death Note: The Last Name", "original_transliteration": "Desu Nooto The Last Name"}
2f2754dd-ea02-4cbc-957e-b4d23f38fc65	20th Century Boys	2008-08-30	142	f	{"20th Century Boys 1: The Beginning of the End"}	{"original_title": "20世紀少年", "original_translation": "20th Century Boys", "original_transliteration": "20 Seiki Shyounen"}
73d1a65b-19cc-456c-98cd-2ab5e14bf18a	Gokusen: The Movie	2009-07-11	118	f	\N	{"original_title": "ごくせん THE MOVIE", "original_translation": "Gokusen the Movie", "original_transliteration": "Gokusen the Movie"}
24222558-97ce-4345-b89b-a8f457b981b1	Deadball	2011-07-23	99	f	\N	{"original_title": "デッドボール", "original_translation": "Deadball", "original_transliteration": "Deddobooru"}
1728c27b-80b3-496a-b1c2-c01dc662ed2d	Tomie: Replay	2000-02-11	95	f	\N	{"original_title": "富江 replay", "original_translation": "Tomie Replay", "original_transliteration": "Tomie Replay"}
424cf769-b58f-4044-ad2e-b9b6aee6c477	Lake of Dracula	1971-06-16	82	f	\N	{"original_title": "呪いの館 血を吸う眼", "original_translation": "House of Curses: Bloodsucking Eyes", "original_transliteration": "Noroi No Yakata Chiwosuu Me"}
bc28d5c1-e623-43b0-b097-c58ac18680bd	Prophecies of Nostradamus	1974-08-03	114	f	{"Catastrophe: 1999","The Last Days of Planet Earth"}	{"original_title": "ノストラダムスの大予言", "original_translation": "Great Prophecies of Nostradamus", "original_transliteration": "Nosutoradamusu No Daiyogen"}
09d7026b-043c-4269-b0b3-c6467fb4fb3a	The Return of Godzilla	1984-12-15	103	f	{"Godzilla 1985"}	{"original_title": "ゴジラ", "original_translation": "Godzilla", "original_transliteration": "Gojira"}
f362dad8-915b-4d38-8d55-9a0d06a950a9	Godzilla VS King Ghidorah	1991-12-14	103	f	\N	{"original_title": "ゴジラvsキングギドラ", "original_translation": "Godzilla VS King Ghidorah", "original_transliteration": "Gojira VS Kingugidora"}
328dd5cf-f425-45cf-a487-4457411b78d1	Ghost in the Shell	1995-11-18	85	f	\N	{"original_title": "攻殻機動隊", "original_translation": "Mobile Armored Riot Police", "original_transliteration": "Koukaku Kidoutai"}
fe6de616-6f61-4c7e-a61e-b892fe6ccddb	Rebirth of Mothra	1996-12-14	106	f	\N	{"original_title": "モスラ", "original_translation": "Mothra", "original_transliteration": "Mosura"}
ea15e6b4-5bac-48d9-836b-eda509c39ba6	Tomie: Another Face	1999-12-26	95	f	\N	{"original_title": "富江 恐怖の美少女", "original_translation": "Tomie: Beautiful Girl of Terror", "original_transliteration": "Tomie Kyoufu No Bishyoujyou"}
8d1d9023-f052-43ba-bec7-3de46d40dc3b	Chaos	2000-10-21	104	f	\N	{"original_title": "カオス", "original_translation": "Chaos", "original_transliteration": "Kaosu"}
804be70b-0082-41f7-8579-c1502f07c1df	Always: Sunset on Third Street	2005-11-05	133	f	\N	{"original_title": "ALWAYS 三丁目の夕日", "original_translation": "Always: Sunset on Third Street", "original_transliteration": "Always San Chyoume No Yuuhi"}
c7a3c4ef-364c-404e-8a16-4a1fce836949	Jin-Roh: The Wolf Brigade	2000-06-03	98	f	\N	{"original_title": "人狼", "original_translation": "Werewolf", "original_transliteration": "Jinrou"}
c40759c6-257e-452d-a313-b4f7114e7db9	Onmyoji II	2003-10-04	115	f	\N	{"original_title": "陰陽師II", "original_translation": "Yin Yang Master II", "original_transliteration": "Onmyouji II"}
a8a2ffad-16c0-4b72-b8aa-f94638e8e3a2	Casshern	2004-04-24	141	f	\N	{"original_title": "キャシャーン", "original_translation": "Casshern", "original_transliteration": "Kyashiaan"}
c35ae200-de99-427d-b769-a8b4df1280ca	Masked Rider: The Next	2007-10-27	113	f	\N	{"original_title": "仮面ライダー THE NEXT", "original_translation": "Masked Rider: The Next", "original_transliteration": "Kamen Raidaa The Next"}
93c6c6f9-c068-4976-9c72-10950be7d973	God's Left Hand, Devil's Right Hand	2006-07-22	95	f	\N	{"original_title": "神の左手悪魔の右手", "original_translation": "God's Left Hand Devil's Right Hand", "original_transliteration": "Kami No Hidarite Akuma No Migite"}
fe9e647e-d817-4ca2-8885-6a7de4e65b7b	20th Century Boys: The Last Hope	2009-01-31	139	f	{"20th Century Boys 2: The Last Hope"}	{"original_title": "20世紀少年 第2章 最後の希望", "original_translation": "20th Century Boys Second Chapter: The Last Hope", "original_transliteration": "20 Seiki Shyounen Dai 2 Shou Saigo No Kibou"}
c512e380-84ba-447a-8ad7-d228d98704b7	Gatchaman	2013-08-24	113	f	\N	{"original_title": "ガッチャマン", "original_translation": "Gatchaman", "original_transliteration": "Gacchyaman"}
842265ea-5b60-41d5-bd6f-a727713dd12f	Evil of Dracula	1974-07-20	83	f	\N	{"original_title": "血を吸う薔薇", "original_translation": "Bloodsucking Rose", "original_transliteration": "Chiwosuu Bara"}
48c3898a-8de2-44dd-8cae-c2983694d0d1	The Bullet Train	1975-07-05	152	f	{"Super Express 109"}	{"original_title": "新幹線大爆破", "original_translation": "Bullet Train Great Explosion", "original_transliteration": "Shinkansen Daibakaha"}
439c5b5d-7127-4f80-bb7a-6fd92fc430b6	Sayonara, Jupiter	1984-03-17	129	f	\N	{"original_title": "さよならジュピター", "original_translation": "Farewell Jupiter", "original_transliteration": "Sayonara Jyupitaa"}
8c6d6694-71ee-4755-9810-4d9e49e9dc76	Zeiram	1991-12-21	97	f	\N	{"original_title": "ゼイラム", "original_translation": "Zeiram", "original_transliteration": "Zeiramu"}
940f82be-26cc-43ae-8fb1-9a144f4fc453	Godzilla 2000	1999-12-11	108	f	\N	{"original_title": "ゴジラ2000 ミレニアム", "original_translation": "Godzilla 2000 Millennium", "original_transliteration": "Gojira 2000 Mireniamu"}
228788dc-95fe-4cf7-b819-2e659fb3f314	Space Battleship Yamato	2010-12-01	138	f	\N	{"original_title": "SPACE BATTLESHIP ヤマト", "original_translation": "Space Battleship Yamato", "original_transliteration": "Space Battleship Yamato"}
5da0a53b-039d-48f1-a7e6-12b23f34354b	Assault Girls	2009-12-19	70	f	\N	{"original_title": "アサルト・ガールズ", "original_translation": "Assault Girls", "original_transliteration": "Asaruto Gaaruzu"}
c09478fe-08da-45ef-b4c2-9ecc076cb73b	Eko Eko Azarak: The Wizard of Darkness	1995-04-08	80	f	\N	{"original_title": "エコエコアザラク -WIZARD OF DARKNESS-", "original_translation": "Eko Eko Azarak: Wizard of Darkness", "original_transliteration": "Eko Eko Azaraku Wizard of Darkness"}
dc903a47-1d7d-4fc6-8608-9955638d3ef1	Rebirth of Mothra 2	1997-12-13	100	f	\N	{"original_title": "モスラ2 海底の大決戦", "original_translation": "Mothra 2: Sea Battle", "original_transliteration": "Mosura 2 Kaitei No Kessen"}
156b1dbb-5379-4355-b6b3-85b1be2e8e7b	Tomie: Rebirth	2001-03-24	101	f	\N	{"original_title": "富江 re-birth", "original_translation": "Tomie Re-Birth", "original_transliteration": "Tomie Re-Birth"}
b91e69c2-1d07-48e7-b3e1-9576417b518d	Battle Royale	2000-12-16	114	f	\N	{"original_title": "バトル・ロワイアル", "original_translation": "Battle Royale", "original_transliteration": "Batoru Rowaiaru"}
a3c23594-00db-4cc9-901a-7bbd87f0c32e	Always: Sunset on Third Street 2	2007-11-03	146	f	\N	{"original_title": "ALWAYS 続・三丁目の夕日", "original_translation": "Always Continued: Sunset on Third Street", "original_transliteration": "Always Zoku San Chyoume No Yuuhi"}
c2c2bbd6-f2e0-41a6-b350-f6e42b1654b6	The Sky Crawlers	2008-08-02	122	f	\N	{"original_title": "スカイ・クロラ", "original_translation": "Sky Crawler", "original_transliteration": "Sukai Kurora"}
cbde47ee-1057-467a-a853-421d97c5440d	The Grudge	2003-01-25	92	f	\N	{"original_title": "呪怨", "original_translation": "Grudge", "original_transliteration": "Jyuon"}
bf991fa1-ed29-4370-9377-ecc1b58126db	Goemon	2009-05-01	128	f	\N	{"original_title": "ゴエモン", "original_translation": "Goemon", "original_transliteration": "Goemon"}
1c16941d-5e6f-4925-aa20-7eee3dd785d3	Shinobi: Heart Under Blade	2005-09-17	101	f	\N	\N
2b01cced-46eb-4c43-aaab-99c8481f2360	Dororo	2007-01-27	138	f	\N	{"original_title": "どろろ", "original_translation": "Dororo", "original_transliteration": "Dororo"}
7e38ded9-ae5c-4b92-bb14-39b55ac5acff	20th Century Boys: Redemption	2009-08-29	155	f	{"20th Century Boys 3: Redemption"}	{"original_title": "20世紀少年 最終章 ぼくらの旗", "original_translation": "20th Century Boys Final Chapter: Our Flag", "original_transliteration": "20 Seiki Shyounen Saishyuushyou Bokura No Hata"}
08560f6a-e21e-40dc-9b24-f1b9c3ee7dcf	Kamui Gaiden	2009-09-19	120	f	{"Kamui: The Lone Ninja"}	{"original_title": "カムイ外伝", "original_translation": "Kamui Story", "original_transliteration": "Kamui Gaiden"}
06b610ac-b58a-4ed0-93eb-63a43b0aaa85	Daigoro vs. Goliath	1972-12-17	85	f	\N	{"original_title": "怪獣大奮戦 ダイゴロウ対ゴリアス", "original_translation": "Big Monster Battle Daigoro Against Goliath", "original_transliteration": "Kaijyuu Daifunsen Daigorou Tai Goriasu"}
d085f568-32be-4037-bfb0-f0206a7b8758	The Explosion	1975-07-12	100	f	\N	{"original_title": "東京湾炎上", "original_translation": "Tokyo Bay Fire", "original_transliteration": "Toukyouwan Enjyou"}
46d52769-4d58-4cec-a521-a57138748655	Makai Tensho: Samurai Reincarnation	1981-06-06	122	f	\N	{"original_title": "魔界転生", "original_translation": "Demon World Incarnation", "original_transliteration": "Makai Tenshyou"}
18c426a6-8cf3-44e0-ac1a-f2d741dda9d1	Talking Head	1992-10-10	105	f	\N	{"original_title": "トーキング・ヘッド", "original_translation": "Talking Head", "original_transliteration": "Tookingu Heddo"}
8028131f-b3eb-486f-a742-8dbbd07a6516	Eko Eko Azarak II: Birth of the Wizard	1996-04-20	83	f	\N	{"original_title": "エコエコアザラクII -BIRTH OF THE WIZARD-", "original_translation": "Eko Eko Azarak II: Birth of the Wizard", "original_transliteration": "Eko Eko Azaraku II Birth of the Wizard"}
286bb8ad-de51-4416-89a7-185e33711092	Rebirth of Mothra 3	1998-12-12	100	f	\N	{"original_title": "モスラ3 キングギドラ来襲", "original_translation": "Mothra 3: King Ghidorah Appears", "original_transliteration": "Mosura 3 Kingugidora Raishyuu"}
98571eeb-d5f6-4eaa-a819-12a21b08cc78	Tomie: Forbidden Fruit	2002-06-29	91	f	\N	{"original_title": "富江 最終章 -禁断の果実-", "original_translation": "Tomie Final Chapter: Forbidden Fruit", "original_transliteration": "Tomie Saishyuushyou Kindan No Kajitsu"}
1fdae7be-7d2f-4a82-ac1c-049f70ba5f21	Battle Royale II: Requiem	2003-07-05	133	f	\N	{"original_title": "バトル・ロワイアルII 鎮魂歌 (レクイエム)", "original_translation": "Battle Royale II Fantasy (Requiem)", "original_transliteration": "Batoru Rowaiaru II Chinkonka (Rekuiemu)"}
df2bc5e1-38b3-4f31-bc99-5c9fc99fdd06	Ballad	2009-09-05	132	f	\N	{"original_title": "BALLAD 名もなき恋のうた", "original_translation": "Ballad: The Nameless Love Song", "original_transliteration": "Ballad Namonaki Koi No Ute"}
48170d76-e893-49a1-aaf7-43b7ffa6e3a7	Avalon	2001-01-20	106	f	\N	{"original_title": "アヴァロン", "original_translation": "Avalon", "original_transliteration": "Avuaron"}
4fea4d88-a085-4624-b86a-373e9088a940	The Grudge 2	2003-08-23	92	f	\N	{"original_title": "呪怨2", "original_translation": "Grudge 2", "original_transliteration": "Jyuon"}
02ea2aa6-32e1-4bd0-8e05-c7f730e48798	Ultraman	2004-12-18	97	f	\N	{"original_title": "ウルトラマン", "original_translation": "Ultraman", "original_transliteration": "Urutoraman"}
8437dbf0-a594-4caf-ac74-9c9eb5c4ca69	Death Trance	2006-05-20	89	f	\N	{"original_title": "デス・トランス", "original_translation": "Death Trance", "original_transliteration": "Desu Toransu"}
fb7218d1-0de2-47c2-a68e-2c819f2025f8	Kaidan	2007-08-04	119	f	\N	{"original_title": "怪談", "original_translation": "Ghost Story", "original_transliteration": "Kaidan"}
d4aa5cbb-8515-4815-a62e-2eef504c6e61	The Sword of Alexander	2007-04-07	110	f	\N	{"original_title": "大帝の剣", "original_translation": "Sword of the Emperor", "original_transliteration": "Taitei No Ken"}
76ee6178-d728-4033-8cfe-01970c1be237	Rurouni Kenshin	2012-08-25	134	f	{"Rurouni Kenshin Part I: Origins"}	{"original_title": "るろうに剣心", "original_translation": "Rurouni Kenshin", "original_transliteration": "Rurouni Kenshin"}
f5e33833-8abd-45df-a623-85ec5cb83d3d	Godzilla vs. the Smog Monster	1971-07-24	85	f	{"Godzilla vs. Hedorah"}	{"original_title": "ゴジラ対ヘドラ", "original_translation": "Godzilla Against Hedorah", "original_transliteration": "Gojira Tai Hedora"}
2bf17c7e-01ae-43be-85f0-9a5c2ef47733	The War in Space	1977-12-17	91	f	\N	{"original_title": "惑星大戦争", "original_translation": "Great Planet War", "original_transliteration": "Wakusei Daisensou"}
d1f33930-3bab-48fc-8fc5-c3339d27c413	The Red Spectacles	1987-02-07	116	f	\N	{"original_title": "紅い眼鏡", "original_translation": "Red Glasses", "original_transliteration": "Akai Megane"}
4a4b6286-fcdc-4755-8870-83196ac7da97	Godzilla VS Mothra	1992-12-12	102	f	{"Godzilla and Mothra: The Battle for Earth"}	{"original_title": "ゴジラvsモスラ", "original_translation": "Godzilla VS Mothra", "original_transliteration": "Gojira VS Mosura"}
15f943e0-ce0c-4421-97a3-627f5c09a856	Eko Eko Azarak III: Misa, the Dark Angel	1998-01-15	95	f	\N	{"original_title": "エコエコアザラクIII -MISA THE DARK ANGEL-", "original_translation": "Eko Eko Azarak III: Misa the Dark Angel", "original_transliteration": "Eko Eko Azaraku III Misa the Dark Angel"}
f42f913d-0daa-478d-8351-24fbe682d437	Parasite Eve	1997-02-01	120	f	\N	{"original_title": "パラサイト・イヴ", "original_translation": "Parasite Eve", "original_transliteration": "Parasaito Ibu"}
d9419337-9051-43e5-b241-882b46b1f1e4	Versus	2001-09-08	119	f	\N	\N
67cae0c6-8e05-45cb-87e7-dfef76e3dcd1	Aragami	2003-03-27	78	f	\N	{"original_title": "荒神", "original_translation": "God of War", "original_transliteration": "Aragami"}
220678c5-6783-436e-a83d-866bc99ea80b	Samurai Commando: Mission 1549	2005-06-11	120	f	\N	{"original_title": "戦国自衛隊1549", "original_translation": "15th Century Self Defense Force 1549", "original_transliteration": "Sengoku Jieitai 1549"}
cd273bbe-60b4-4395-b971-83062b4a6cfa	Mushi-shi	2007-03-24	131	f	\N	{"original_title": "蟲師", "original_translation": "Bug Master", "original_transliteration": "Mushishi"}
c4dff626-aed3-4a1e-9823-3315be614257	L: Change the World	2008-02-09	129	f	\N	{"original_title": "L change the WorLd", "original_translation": "L: Change the World", "original_transliteration": "L Change the World"}
9241a8af-96f9-4297-a21c-2fd39cafc9d0	Sweet Rain: The Accuracy of Death	2008-03-22	113	f	\N	{"original_title": "死神の精度", "original_translation": "Accuracy of Death", "original_transliteration": "Shinigami No Seido"}
eb390ec6-d2c1-432a-b10c-15e237c8532a	Rurouni Kenshin: Kyoto Inferno	2014-08-01	139	f	{"Rurouni Kenshin Part II: Kyoto Inferno"}	{"original_title": "るろうに剣心 京都大火編", "original_translation": "Rurouni Kenshin Kyoto Inferno", "original_transliteration": "Rurouni Kenshin Kyouto Taikahen"}
258a91ff-f401-473a-b93f-604b85d8a406	Godzilla on Monster Island	1972-03-12	89	f	{"Godzilla vs. Gigan"}	{"original_title": "地球攻撃命令 ゴジラ対ガイガン", "original_translation": "Earth Destruction Order: Godzilla Against Gigan", "original_transliteration": "Chikyuu Kougeki Meirei Gojira Tai Gaigan"}
646d0a87-d4c3-48c0-8bfb-de5db26233d7	Message from Space	1978-04-29	105	f	\N	{"original_title": "宇宙からのメッセージ", "original_translation": "Message from Space", "original_transliteration": "Uchyuu Kara No Messeeji"}
f5eb5937-5b71-4b22-9e9b-c3346f113e50	Tokyo Blackout	1987-01-17	120	f	\N	{"original_title": "首都消失", "original_translation": "Capital Disappears", "original_transliteration": "Shyuto Shyoushitsu"}
9d0541e8-1c7a-46fd-97da-8793c2ecb4ba	Patlabor 2: The Movie	1993-08-07	113	f	\N	{"original_title": "機動警察パトレイバー2 the Movie", "original_translation": "Mobile Police Patlabor 2: The Movie", "original_transliteration": "Kidoukeisatsu Patoreibaa 2 The Movie"}
f318f528-7c69-40df-a91d-88411c979e67	Gamera: The Guardian of the Universe	1995-03-11	95	f	\N	{"original_title": "ガメラ 大怪獣空中決戦", "original_translation": "Gamera: Giant Monster Air Battle", "original_transliteration": "Gamera Daikaijyuu Kuuchyuu Kessen"}
b73255d8-4457-4a39-bf7f-e59273d04b88	Ring	1998-01-31	95	f	\N	{"original_title": "リング", "original_translation": "Ring", "original_transliteration": "Ringu"}
6a6dc0b2-0fa6-48ba-b444-bb6a723877ee	Godzilla X Megaguirus	2000-12-16	105	f	\N	{"original_title": "ゴジラ×メガギラス G消滅作戦", "original_translation": "Godzilla X Megaguirus: G Annihilation Strategy", "original_transliteration": "Gojira X Megagirasu G Shyoumetsu Sakusen"}
135cec93-8734-4a8a-b7a7-9c5e90e38e26	Alive	2003-06-21	119	f	\N	\N
aae318c6-45cb-4cb0-b67c-a92d3f124bde	Friends	2011-12-17	87	f	\N	{"original_title": "friends もののけ島のナキ", "original_translation": "Friends: Naki of Monster Island", "original_transliteration": "Friends Mononoke Shima No Naki"}
67877b75-fcb4-440b-a182-6f2228c9ea91	The Princess Blade	2001-12-15	93	f	\N	{"original_title": "修羅雪姫", "original_translation": "Lady Snowblood", "original_transliteration": "Shyurayuki Hime"}
f5cab5fa-f1e8-44e3-940f-30c9144bc5e4	Sky High	2003-11-08	123	f	\N	{"original_title": "スカイハイ", "original_translation": "Sky High", "original_transliteration": "Sukai Hai"}
38418f59-0ae8-4ed9-98f9-a4f058074d45	Rescue Wings	2008-12-13	108	f	\N	{"original_title": "空へ-救いの翼 RESCUE WINGS-", "original_translation": "To the Sky, Wings of Salvation: Rescue Wings", "original_transliteration": "Sorae Sukui No Tsubasa Rescue Wings"}
ace24bd7-2b26-40bb-a818-0404e0f4606e	Retribution	2007-02-24	104	f	\N	{"original_title": "叫", "original_translation": "Cry", "original_transliteration": "Sakebi"}
c0111612-5ad6-4982-b895-75d8e351f23a	Genghis Khan: To the Ends of the Earth and Sea	2007-03-03	136	f	\N	{"original_title": "蒼き狼 地果て海尽きるまで", "original_translation": "Blue Wolf To the Ends of the Earth and Sea", "original_transliteration": "Aoki Ookami Chisate Umitsukiru Made"}
92eaa465-8b94-49d6-9726-564a064b3d2b	K-20: The Fiend with Twenty Faces	2008-12-20	137	f	\N	{"original_title": "K-20 怪人二十面相・伝", "original_translation": "K-20 Phantom with Twenty Faces Legend", "original_transliteration": "K-20 Kaijin Nijyuu Mensou Den"}
a3112f14-09ae-474a-9eb8-b390d0637dd0	Rurouni Kenshin: The Legend Ends	2014-09-13	135	f	{"Rurouni Kenshin Part III: The Legend Ends"}	{"original_title": "るろうに剣心 伝説の最期編", "original_translation": "Rurouni Kenshin Legend Final Chapter", "original_transliteration": "Rurouni Kenshin Densetsu No Saigohen"}
ead6a8bb-36ee-46db-bd54-0761b0dd3d22	Godzilla vs. Megalon	1973-03-17	82	f	\N	{"original_title": "ゴジラ対メガロ", "original_translation": "Godzilla Against Megalon", "original_transliteration": "Gojira Tai Megaro"}
9bf400db-c02d-4502-b9dd-446e7d3fe231	G. I. Samurai	1979-12-15	139	f	{"Time Slip"}	{"original_title": "戦国自衛隊", "original_translation": "15th Century Self Defense Force", "original_transliteration": "Sengoku Jieitai"}
6a995dc7-1239-4f95-8fb3-2905b26ead3c	Akira	1988-07-16	124	f	\N	{"original_title": "アキラ", "original_translation": "Akira", "original_transliteration": "Akira"}
e0c22c94-00bf-42c2-b0f1-f4189ba6e60e	Godzilla VS Mechagodzilla	1993-12-11	108	f	{"Godzilla vs. Mechagodzilla II"}	{"original_title": "ゴジラvsメカゴジラ", "original_translation": "Godzilla VS Mechagodzilla", "original_transliteration": "Gojira VS Mekagojira"}
e5bbd431-fc4f-40f8-875c-2aa3a94e7dcb	Gamera 2: Advent of Legion	1996-07-13	99	f	{"Gamera 2: Attack of Legion"}	{"original_title": "ガメラ2 レギオン襲来", "original_translation": "Gamera 2: Legion Attack", "original_transliteration": "Gamera 2 Region Shyuurai"}
07f023e7-46b1-44e8-a896-4897c25ca928	Rasen	1998-01-31	97	f	\N	{"original_title": "らせん", "original_translation": "Spiral", "original_transliteration": "Rasen"}
d47406e8-fd4b-4031-87e9-387f905eeb13	GMK	2001-12-15	105	f	\N	{"original_title": "ゴジラ・モスラ・キングギドラ 大怪獣総攻撃", "original_translation": "Godzilla, Mothra, King Ghidorah: Giant Monsters All Out Attack", "original_transliteration": "Gojira Mosura Kingugidora Daikaijyuu Soukougeki"}
2a3810e7-dee8-45c2-8982-5730cc86e50c	Azumi	2003-05-10	142	f	\N	{"original_title": "あずみ", "original_translation": "Azumi", "original_transliteration": "Azumi"}
5988c778-2ffb-4036-8341-962e43b21b7d	Always: Sunset on Third Street '64'	2012-01-21	142	f	\N	{"original_title": "ALWAYS 三丁目の夕日'64", "original_translation": "Always: Sunset on Third Street '64", "original_transliteration": "Always San Chyoume No Yuuhi '64'"}
113ece47-aff0-4d03-9096-f9f7830f5528	Tetsujin-28	2005-03-19	114	f	\N	{"original_title": "鉄人28号", "original_translation": "Iron Man No. 28", "original_transliteration": "Tetsujin Nijyuu Hachi Gou"}
e867eee7-3dfb-4a98-88d4-94ab919efb14	LoveDeath	2007-05-12	158	f	\N	\N
6f7545a5-808f-49a1-88e0-b444d1a56f29	Sukiyaki Western Django	2007-09-15	121	f	\N	{"original_title": "スキヤキ・ウエスタン ジャンゴ", "original_translation": "Sukiyaki Western Django", "original_transliteration": "Sukiyaki Uesutan Jyango"}
a3847c07-94a1-4ed0-bf99-30f71334aa12	The Glorious Team Batista	2008-02-09	118	f	\N	{"original_title": "チーム・バチスタの栄光", "original_translation": "Glory of Team Batista", "original_transliteration": "Chiimu Bachisuta No Eikou"}
c6499a6a-358d-48a2-ace3-acb7a4af3d29	Platinum Data	2013-03-16	133	f	\N	{"original_title": "プラチナデータ", "original_translation": "Platina Data", "original_transliteration": "Purachina Deeta"}
b36b76fa-643c-4c91-bf67-f73c7482ba94	Terror of Mechagodzilla	1975-03-15	83	f	{"Terror of Godzilla"}	{"original_title": "メカゴジラの逆襲", "original_translation": "Counterattack of Mechagodzilla", "original_transliteration": "Mekagojira No Gyakushyuu"}
c6ea0d4e-7a68-45cb-9da4-c9eae71b705e	Earthquake Archipelago	1980-08-30	126	f	{Deathquake}	{"original_title": "地震列島", "original_translation": "Earthquake Archipelago", "original_transliteration": "Jishin Rettou"}
baa6395c-0362-4423-a6bb-a71d94e449b9	Patlabor: The Movie	1989-07-15	100	f	\N	{"original_title": "機動警察パトレイバー the Movie", "original_translation": "Mobile Police Patlabor: The Movie", "original_transliteration": "Kitoukeisatsu Patoreibaa The Movie"}
d141f540-c0e2-43b4-be80-06f510646d52	Godzilla VS Space Godzilla	1994-12-10	108	f	\N	{"original_title": "ゴジラvsスペースゴジラ", "original_translation": "Godzilla VS Space Godzilla", "original_transliteration": "Gojira VS Supeesugojira"}
9595f0f3-16ab-47e9-9668-fdbb080091ee	Godzilla VS Destroyer	1995-12-09	103	f	{"Godzilla vs. Destoroyah"}	{"original_title": "ゴジラvsデストロイア", "original_translation": "Godzilla VS Destroyer", "original_transliteration": "Gojira VS Desutoroia"}
3df82c9d-f929-4cfe-9b94-d7356b30f32f	Ring 0: Birthday	2000-01-22	99	f	\N	{"original_title": "リング0 バースデイ", "original_translation": "Ring 0: Birthday", "original_transliteration": "Ringu 0 Baasudei"}
21fd4b5c-720f-42b5-8751-94d42bf6be02	Godzilla X Mothra X Mechagodzilla: Tokyo SOS	2003-12-13	91	f	\N	{"original_title": "ゴジラ×モスラ×メカゴジラ 東京SOS", "original_translation": "Godzilla X Mothra X Mechagodzilla: Tokyo SOS", "original_transliteration": "Gojira X Mosura X Mekagojira Toukyou SOS"}
3c815067-d376-4b39-a9a6-dfe31a1dbb57	Crossfire	2000-06-10	115	f	{Pyrokinesis}	{"original_title": "クロスファイア", "original_translation": "Crossfire", "original_transliteration": "Kurosufaia"}
5449600a-b42d-4b3b-8551-4bfce2101463	Stand By Me, Doraemon	2014-08-08	95	f	\N	{"original_title": "STAND BY ME ドラえもん", "original_translation": "Stand By Me, Doraemon", "original_transliteration": "Stand By Me Doraemon"}
a4641997-f1b1-4a18-b269-2b91914292cb	Library Wars	2013-04-27	128	f	\N	{"original_title": "図書館戦争", "original_translation": "Library War", "original_transliteration": "Toshyoukan Sensou"}
cfaf4ab5-af6a-417b-91ee-65ad2af67155	One Missed Call: Final	2006-06-24	105	f	\N	{"original_title": "着信アリFinal", "original_translation": "Incoming Call Final", "original_transliteration": "Chyakushin Ari Final"}
a189e004-9ee6-4c76-90c6-b4630efccd95	The Sinking of Japan	2006-07-15	135	f	\N	{"original_title": "日本沈没", "original_translation": "Japan Sunk", "original_transliteration": "Nippon Chinbotsu"}
7e322ca6-fe1c-4c13-9b6d-4991f675f2ed	Gamera the Brave	2006-04-29	96	f	\N	{"original_title": "小さき勇者たち〜ガメラ〜", "original_translation": "The Little Braves: Gamera", "original_transliteration": "Chisaki Yuushyatachi Gamera"}
37e6a670-8016-4594-ba9b-070dd2c76311	Hara-Kiri: Death of a Samurai	2011-10-15	126	f	\N	{"original_title": "一命", "original_translation": "Life", "original_transliteration": "Ichimei"}
0c035d95-032c-4975-8693-1058d6676add	Kaiji	2009-10-10	129	f	\N	{"original_title": "カイジ", "original_translation": "Kaiji", "original_transliteration": "Kaiji"}
32feba7e-991a-4f63-90e4-31765bf552bd	Zatoichi	1989-02-04	116	f	{"Zatoichi: The Blind Swordsman","Zatoichi: Darkness is His Ally"}	{"original_title": "座頭市", "original_translation": "Zatoichi", "original_transliteration": "Zatouichi"}
65abec00-0bd3-48d7-9394-7816acfe04a3	Daredevil in the Castle	1961-01-03	95	f	\N	{"original_title": "大坂城物語", "original_translation": "Osaka Castle Story", "original_transliteration": "Oosakajyou Monogatari"}
e30025d4-8bbc-476e-ba1c-7030dfa7ddb2	Whirlwind	1964-01-03	106	f	\N	{"original_title": "士魂魔道 大龍巻", "original_translation": "Buddhist Spirit Great Tornado", "original_transliteration": "Shikonmadou Daitatsumaki"}
b286aeb7-b2b2-44bd-b8d0-926e7682d1d2	Dark Water	2002-01-19	101	f	\N	{"original_title": "仄暗い水の底から", "original_translation": "Dark Water from the Bottom", "original_transliteration": "Honokurai Mizu No Soko Kara"}
897f493c-cd9b-485d-8aa6-3459792e4fd8	The Sword of Doom	1966-02-25	120	f	\N	{"original_title": "大菩薩峠", "original_translation": "Great Bodhisattva Pass", "original_transliteration": "Daibasatsu Touge"}
590ec282-c912-4887-91d3-15fb7f581f40	The Tale of Zatoichi	1962-04-18	96	f	\N	{"original_title": "座頭市物語", "original_translation": "Zatouichi Monogatari", "original_transliteration": "Story of Zatoichi"}
39675aec-9067-4575-a1a1-9fbecdd88675	The Tale of Zatoichi Continues	1962-10-12	73	f	\N	{"original_title": "続・座頭市物語", "original_translation": "Zoku Zatouichi Monogatari", "original_transliteration": "Story of Zatoichi Continued"}
979f5970-26c8-476a-9e55-3844963ee9a1	New Tale of Zatoichi	1963-03-15	91	f	\N	{"original_title": "新・座頭市物語", "original_translation": "Shin Zatouichi Monogatari", "original_transliteration": "New Story of Zatoichi"}
4c6b33c0-c731-4b31-a84c-4ef3e8edcf9c	Zatoichi the Fugitive	1963-08-10	86	f	\N	{"original_title": "座頭市兇状旅", "original_translation": "Zatouichi Kyoujyoutabi", "original_transliteration": "Zatoichi Funeral Journey"}
7e76cb19-b5c2-4090-b8f3-ec4aa47c5636	Zatoichi on the Road	1963-11-30	88	f	\N	{"original_title": "座頭市喧嘩旅", "original_translation": "Zatouichi Kenkatabi", "original_transliteration": "Zatoichi Fighting Journey"}
815adb31-c73a-4a87-a6b5-7ed3230a5d21	Zatoichi and the Chest of Gold	1964-03-14	83	f	\N	{"original_title": "座頭市千両首", "original_translation": "Zatouichi Senryoukubi", "original_transliteration": "Zatoichi Thousand Ryo Neck"}
6818987e-5678-465e-84c9-0465a25bcac3	Zatoichi's Flashing Sword	1964-07-11	82	f	\N	{"original_title": "座頭市あばれ凧", "original_translation": "Zatouichi Abaredako", "original_transliteration": "Zatoichi Wild Kite"}
fa1784bb-e22e-4f7c-a9f8-cdfd0e0052f6	Fight, Zatoichi, Fight	1964-10-17	87	f	\N	{"original_title": "座頭市血笑旅", "original_translation": "Zatouichi Kesshyoutabi", "original_transliteration": "Zatoichi Blood Smile Journey"}
079eedd8-33f5-45f4-a45b-53d8cdd5aaba	Adventures of Zatoichi	1964-12-30	86	f	\N	{"original_title": "座頭市関所破り", "original_translation": "Zatouichi Sekishyou Yaburi", "original_transliteration": "Zatoichi Barrier Break"}
7f698138-a8f1-47cc-a15e-5d144cce176b	Zatoichi's Revenge	1965-04-03	84	f	\N	{"original_title": "座頭市二段斬り", "original_translation": "Zatouichi Nidankiri", "original_transliteration": "Zatoichi Two-Step Slash"}
ed4456f3-4bf8-4cb5-b606-ec727cf522d9	Samaritan Zatoichi	1968-12-28	82	f	\N	{"original_title": "座頭市喧嘩太鼓", "original_translation": "Zatouichi Kenkadaiko", "original_transliteration": "Zatoichi War Drum"}
072b2fb3-3b71-49b9-a33c-1fab534f8fea	Zatoichi Meets Yojimbo	1970-01-15	115	f	\N	{"original_title": "座頭市と用心棒", "original_translation": "Zatouichi To Yojinbou", "original_transliteration": "Zatoichi and Yojimbo"}
ed9ad73c-2b06-490c-9409-e5c8dec2f583	Zatoichi and the Doomed Man	1965-09-18	78	f	\N	{"original_title": "座頭市逆手斬り", "original_translation": "Zatouichi Sakategiri", "original_transliteration": "Zatoichi Enemy Slashing"}
9fbcb82b-d10b-4790-88b1-c4734ed11258	Zatoichi Goes to the Fire Festival	1970-08-12	96	f	\N	{"original_title": "座頭市あばれ火祭り", "original_translation": "Zatouichi Abarehi Matsuri", "original_transliteration": "Zatoichi Fire Festival"}
6d07b165-ef5c-40ab-ad68-e53e8bc9f7fa	Zatoichi and the Chess Expert	1965-12-24	87	f	\N	{"original_title": "座頭市地獄旅", "original_translation": "Zatouichi Jigokutabi", "original_transliteration": "Zatoichi Hell Journey"}
650f80b2-ef90-4fe3-abec-08c5befc3955	Zatoichi Meets the One-Armed Swordsman	1971-01-13	94	f	\N	{"original_title": "新座頭市・破れ！唐人剣", "original_translation": "Shin Zatouichi Yabare! Toujinken", "original_transliteration": "New Zatoichi Slash! Tangese Sword"}
0da7c76b-1bdb-41d0-a403-79109f7804f8	Zatoichi's Vengeance	1966-05-03	83	f	\N	{"original_title": "座頭市の歌が聞える", "original_translation": "Zatouichi No Utaga Kikoeru", "original_transliteration": "Listening to Song of Zatoichi"}
21e27984-4ac9-4a94-b056-9b8c1649a02f	Zatoichi at Large	1972-01-15	90	f	\N	{"original_title": "座頭市御用旅", "original_translation": "Zatouichi Goyoutabi", "original_transliteration": "Zatoichi Favorite Journey"}
9a26d075-9c52-4795-a209-40844549a919	Zatoichi's Pilgrimage	1966-08-13	82	f	\N	{"original_title": "座頭市海を渡る", "original_translation": "Zatouichi Umi O Wataru", "original_transliteration": "Zatoichi Cross the Ocean"}
381c515c-e1bf-49bd-81c0-0126e2bf6719	Zatoichi in Desperation	1972-09-02	95	f	\N	{"original_title": "新座頭市物語・折れた杖", "original_translation": "Shin Zatouichi Monogatari Oreta Tsue", "original_transliteration": "New Story of Zatoichi Broken Cane"}
0eef4e8f-4c53-480f-a875-8659546a943e	Zatoichi's Cane Sword	1967-01-03	93	f	\N	{"original_title": "座頭市鉄火旅", "original_translation": "Zatouichi Tekkatabi", "original_transliteration": "Zatoichi Fire Journey"}
8ac9d4ae-b517-4372-9e42-2e327cd0d95c	Zatoichi's Conspiracy	1973-04-21	88	f	\N	{"original_title": "新座頭市物語・笠間の血祭り", "original_translation": "Shin Zatouichi Monogatari Kasama No Chimatsuri", "original_transliteration": "New Story of Zatoichi Kasama Blood Festival"}
b37e654d-9604-45bb-9b18-aad485e4b30d	Zatoichi the Outlaw	1967-08-12	96	f	\N	{"original_title": "座頭市牢破り", "original_translation": "Zatouichi Rouyaburi", "original_transliteration": "Zatoichi Jailbreak"}
ac6e5a74-3b42-416d-a73a-93ceced56b19	Zatoichi Challenged	1967-12-30	87	f	\N	{"original_title": "座頭市血煙り街道", "original_translation": "Zatouichi Chikemurikaidou", "original_transliteration": "Zatoichi Blood Smoke Road"}
5810d823-af91-47ae-ab7d-20a34efbda83	Zatoichi and the Fugitives	1968-08-10	82	f	\N	{"original_title": "座頭市果し状", "original_translation": "Zatouichi Hatashijyou", "original_transliteration": "Zatoichi Letter of Challenge"}
6d87cd92-cf55-4369-8081-6f331d4119bf	Zatoichi: The Blind Swordsman	2003-09-06	115	f	\N	{"original_title": "座頭市", "original_translation": "Zatoichi", "original_transliteration": "Zatouichi"}
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	Warning from Space	1956-01-29	82	t	\N	{"original_title": "宇宙人東京に現わる", "original_translation": "Space Men Appear in Tokyo", "original_transliteration": "Uchyuujin Toukyou Ni Arawaru"}
9ec4301a-1522-4af9-b83b-92d50b4f0db9	Daimajin	1966-04-17	84	t	\N	{"original_title": "大魔神", "original_translation": "Great Demon", "original_transliteration": "Daimajin"}
ff2cfc4e-76d6-4985-811f-834d4b7f5485	Return of Daimajin	1966-08-13	79	t	{"The Wrath of Daimajin"}	{"original_title": "大魔神怒る", "original_translation": "Great Demon Grows Angry", "original_transliteration": "Daimajin Okoru"}
b093530b-88fa-4439-bce1-aaf1b066b5ba	The Living Skeleton	1968-11-09	81	t	\N	{"original_title": "吸血髑髏船", "original_translation": "Blood Sucking Skeleton Ship", "original_transliteration": "Kyuuketsu Dokurosen"}
6c45cc47-8f6d-4861-95ab-4c9a2b404218	Samurai II: Duel at Ichijoji Temple	1955-07-12	103	t	\N	{"original_title": "續宮本武蔵 一乘寺の決斗", "original_translation": "Continued Miyamoto Musashi: Duel of Ichijoji Temple", "original_transliteration": "Zoku Miyamoto Musashi Ichijyouji No Kettou"}
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	Samurai III: Duel at Ganryu Island	1956-01-03	104	t	\N	{"original_title": "宮本武蔵 完結篇 決闘巌流島", "original_translation": "Miyamoto Musashi Completion: Duel Ganryu Island", "original_transliteration": "Miyamoto Musashi Kanketsuhen Kettou Ganryuushima"}
\.


--
-- Data for Name: group_memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY group_memberships (group_id, person_id) FROM stdin;
5bbcef55-15b8-4fc1-a507-a115d57bfbbf	b8fae912-626e-4e22-aac4-10062bd7082f
5bbcef55-15b8-4fc1-a507-a115d57bfbbf	701ee638-17cf-45b4-8815-95f87d4caf9a
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY groups (id, name, showcase, active_start, active_end, props) FROM stdin;
5bbcef55-15b8-4fc1-a507-a115d57bfbbf	The Peanuts	t	1959	1975	{"original_name": "&#12470;&#12539;&#12500;&#12540;&#12490;&#12483;&#12484;"}
660408b0-763e-451b-a3de-51cad893c087	The Bambi Pair	f	\N	\N	{"original_name": "&#12506;&#12450;&#12539;&#12496;&#12531;&#12499;"}
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY people (id, given_name, family_name, gender, showcase, dob, dod, birth_place, death_place, aliases, other_names) FROM stdin;
dd78923c-483a-474d-9b5a-11d4cc6b72dc	Nick	Adams	M	t	{"day": 10, "year": 1931, "month": 7}	{"day": 7, "year": 1968, "month": 2}	Nanticoke, Pennsylvania, United States	Beverly Hills, California, United States	\N	{"birth_name": "Nicholas Aloysius Adamschock", "japanese_name": "&#12491;&#12483;&#12463;&#12539;&#12450;&#12480;&#12512;&#12473;"}
2869c9ca-e710-4a53-a103-ff393b129884	Eiji	Tsuburaya	M	t	{"day": 7, "year": 1901, "month": 7}	{"day": 25, "year": 1970, "month": 1}	Sukagawa, Fukushima, Japan	Ito, Shizuoka, Japan	\N	{"birth_name": "Eiichi Tsuburaya (&#20870;&#35895; &#33521;&#19968;)", "original_name": "&#20870;&#35895; &#33521;&#20108;"}
c4d992f8-9b89-4eda-ae22-192e469d5c9f	Motoyoshi	Oda	M	t	{"day": 21, "year": 1909, "month": 7}	{"day": 21, "year": 1973, "month": 10}	Mojiko, Fukuoka, Japan	\N	\N	{"original_name": "&#23567;&#30000; &#22522;&#32681;"}
890b42f6-f12a-4afb-8b82-e1f37a6b4dc9	Jun	Fukuda	M	t	{"day": 17, "year": 1923, "month": 2}	{"day": 3, "year": 2000, "month": 12}	New Kyoto, Manchuria	\N	\N	{"original_name": "&#31119;&#30000; &#32020;"}
ca4cc2b9-e3bd-4219-a758-b024d9b511db	Senkichi	Taniguchi	M	t	{"day": 19, "year": 1912, "month": 2}	{"day": 29, "year": 2007, "month": 10}	Tokyo, Japan	\N	\N	{"original_name": "&#35895;&#21475; &#21315;&#21513;"}
20412681-252e-48bb-a69f-4617d10bbdb1	Shue	Matsubayashi	M	t	{"day": 7, "year": 1920, "month": 7}	{"day": 15, "year": 2009, "month": 8}	Sakurae, Gotsu, Shimane, Japan	\N	\N	{"original_name": "&#26494;&#26519; &#23447;&#24800;"}
d1cffc90-6783-4054-ba9f-032d593fc60c	Shigeru	Kayama	M	t	{"day": 1, "year": 1904, "month": 7}	{"day": 7, "year": 1975, "month": 2}	Tokyo, Japan	\N	\N	{"birth_name": "Koji Yamada (&#23665;&#30000; &#37440;&#27835;)", "original_name": "&#39321;&#23665; &#28363;"}
54122b4f-936f-47e5-a637-3ba3d24763b9	Masaru	Sato	M	t	{"day": 29, "year": 1928, "month": 5}	{"day": 5, "year": 1999, "month": 12}	Rumoi, Hokkaido, Japan	\N	\N	{"original_name": "&#20304;&#34276; &#21213;"}
61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Kaoru	Mabuchi	M	t	{"day": 4, "year": 1911, "month": 2}	{"day": 3, "year": 1987, "month": 5}	Osaka, Japan		{"Takeshi Kimura (&#26408;&#26449; &#27494;)"}	{"original_name": "&#39340;&#28149; &#34219;"}
7a824d10-6fce-4915-9b7b-47a8a3bf5915	Shinichi	Sekizawa	M	t	{"day": 20, "year": 1920, "month": 6}	{"day": 19, "year": 1992, "month": 11}	Kyoto, Japan	\N	\N	{"original_name": "&#38306;&#27810; &#26032;&#19968;"}
a3950f6b-b64a-4bd3-ba7e-a86641c7763e	Yasuyuki	Inoue	M	t	{"day": 26, "year": 1922, "month": 11}	{"day": 19, "year": 2012, "month": 2}	Fukuoka, Japan	\N	\N	{"original_name": "&#20117;&#19978; &#27888;&#24184;"}
f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Teruyoshi	Nakano	M	t	{"day": 9, "year": 1935, "month": 10}	\N	Dandong, China	\N	\N	{"original_name": "&#20013;&#37326; &#26157;&#24950;"}
2aec7762-810f-40b3-943c-211bc049d319	Akira	Takarada	M	t	{"day": 29, "year": 1934, "month": 4}	\N	Hamgyeongbuk-do, Korea	\N	\N	{"original_name": "&#23453;&#30000; &#26126;"}
792be715-31b9-4b8c-8ddf-38fbea1e4101	Akihiko	Hirata	M	t	{"day": 16, "year": 1927, "month": 12}	{"day": 25, "year": 1984, "month": 7}	Gyeongseong, Korea	\N	\N	{"birth_name": "Akihiko Onoda (&#23567;&#37326;&#30000; &#26157;&#24422;)", "original_name": "&#24179;&#30000; &#26157;&#24422;"}
bd14a659-bf60-4b65-9ec2-514bad9ccb72	Takashi	Shimura	M	t	{"day": 12, "year": 1905, "month": 3}	{"day": 11, "year": 1982, "month": 2}	Ikuno, Asago, Hyogo, Japan	Shinjuku, Tokyo, Japan	\N	{"birth_name": "Shoji Shimazaki (&#23798;&#23822; &#25463;&#29246;)", "original_name": "&#24535;&#26449; &#21932;"}
3881d7da-94c0-408b-b384-1133f2c55f46	Fuyuki	Murakami	M	t	{"day": 23, "year": 1911, "month": 12}	{"day": 5, "year": 2007, "month": 4}	Tokuyama, Yamaguchi, Japan	Meguro, Tokyo, Japan	\N	{"birth_name": "Saishu Murakami (&#26449;&#19978; &#28168;&#24030;)", "original_name": "&#26449;&#19978; &#20908;&#27193;"}
56679376-b60c-4926-ae33-3c99ae021778	Ren	Yamamoto	M	t	{"day": 12, "year": 1930, "month": 5}	{"day": 17, "year": 2003, "month": 6}	Minamiashigara, Ashigarakami, Kanagawa, Japan	\N	\N	{"birth_name": "Kiyoshi Yamamoto (&#23665;&#26412; &#24265;)", "original_name": "&#23665;&#26412; &#24265;"}
135f83a7-6249-4068-b8ba-4319b3a2b49e	Kuninori	Kodo	M	t	{"day": 29, "year": 1887, "month": 1}	{"day": 22, "year": 1960, "month": 1}	Takasago, Hyogo, Japan	\N	\N	{"birth_name": "Saichiro Tanikawa (&#35895;&#24029; &#20304;&#24066;&#37070;)", "original_name": "&#39640;&#22530; &#22269;&#20856;"}
f9221586-cca1-42ce-82c9-310042ffe9fe	Ren	Imaizumi	M	t	\N	\N	\N	\N	\N	{"original_name": "&#20170;&#27849;&#24265;"}
5240cb5f-b0a8-4c64-aa01-93a65b45d419	Saburo	Iketani	M	t	{"day": 19, "year": 1923, "month": 8}	{"day": 19, "year": 2002, "month": 10}	Chuo, Tokyo, Japan	\N	\N	{"original_name": "&#27744;&#35895; &#19977;&#37070;"}
f5b35e44-efd4-4298-8124-4bccd4325e23	Katsumi	Tezuka	M	t	{"day": 21, "year": 1912, "month": 8}	{"unknown": 1}	\N	\N	\N	{"original_name": "&#25163;&#22618; &#21213;&#24051;"}
9b787e61-5c06-463d-aa62-18c142735fc8	Haruo	Nakajima	M	t	{"day": 1, "year": 1929, "month": 1}	\N	Sakata, Yamagata, Japan	\N	\N	{"original_name": "&#20013;&#23798; &#26149;&#38596;"}
468e289d-6838-4fb7-b710-7b47a209e5d0	Seijiro	Onda	M	t	\N	\N	\N	\N	\N	{"original_name": "&#24681;&#30000;&#28165;&#20108;&#37070;"}
580c0f24-0d62-4891-91dd-3f0f52b834d7	Kichijiro	Ueda	M	t	{"day": 30, "year": 1904, "month": 3}	{"day": 3, "year": 1972, "month": 11}	Sannomiya, Kobe, Hyogo, Japan	Kojimacho, Chofu, Tokyo, Japan	\N	{"birth_name": "Sadao Ueda (&#19978;&#30000; &#23450;&#38596;)", "original_name": "&#19978;&#30000; &#21513;&#20108;&#37070;"}
efaedbdc-65d4-4bdd-904c-3eb10cfe25d9	Kaoru	Yachigusa	F	t	{"day": 6, "year": 1931, "month": 1}	\N	Osaka, Japan	\N	\N	{"birth_name": "Hitomi Matsuda (&#26494;&#30000; &#30643;)", "original_name": "&#20843;&#21315;&#33609; &#34219;"}
e18af03d-2ca1-4c1d-9689-761a12ded64f	Chishu	Ryu	M	t	{"day": 13, "year": 1904, "month": 5}	{"day": 16, "year": 1993, "month": 3}	Tachibana, Tamamizu, Tamana, Kumamoto, Japan	\N	\N	{"original_name": "&#31520; &#26234;&#34886;"}
0a4287a6-254e-42ce-b2fa-1a403c80947b	Kazuo	Suzuki	M	t	{"day": 18, "year": 1937, "month": 1}	\N	Tokyo, Japan	\N	\N	{"original_name": "&#37428;&#26408; &#21644;&#22827;"}
e55d872b-7180-48d9-a4ae-dbb5c3912e73	Chotaro	Togin	M	t	{"day": 18, "year": 1941, "month": 11}	\N	Arakawa, Tokyo, Japan	\N	\N	{"original_name": "&#24403;&#37504; &#38263;&#22826;&#37070;"}
dce8d29d-b85c-4394-80f8-5e3c910f391f	Andrew	Hughes	M	t	{"year": 1908}	{"unknown": 1}	Turkey	\N	\N	{"japanese_name": "&#12450;&#12531;&#12489;&#12522;&#12517;&#12540;&#12539;&#12498;&#12517;&#12540;&#12474;"}
be4ac231-b431-4c18-b5a9-851e2a7713f1	Masaaki	Tachibana	M	t	{"day": 18, "year": 1925, "month": 3}	{"unknown": 1}	\N	\N	\N	{"original_name": "&#27224; &#27491;&#26179;"}
b3d271ee-f159-45dd-b774-cc823c21d82d	Wataru	Omae	M	t	{"day": 14, "year": 1934, "month": 2}	\N	Gunma, Japan	\N	\N	{"original_name": "&#22823;&#21069; &#20120;"}
b6c06259-91a2-4c9f-ae59-1ccedf1f3b58	Rhodes	Reason	M	t	{"day": 19, "year": 1930, "month": 4}	{"day": 26, "year": 2014, "month": 12}	Glendale, California, United States	Palm Springs, California, United States	\N	{"japanese_name": "&#12525;&#12540;&#12474;&#12539;&#12522;&#12540;&#12474;&#12531;"}
f9094a20-8286-4b66-bd41-eafd905c9d83	Toki	Shiozawa	F	t	{"day": 1, "year": 1928, "month": 4}	{"day": 17, "year": 2007, "month": 5}	Nakazato, Ushigome, Tokyo, Japan	Meguro, Tokyo, Japan	\N	{"original_name": "&#22633;&#27810; &#12392;&#12365;"}
3b4f6a36-44b7-4b23-af88-d03beec21e4d	Masao	Shimizu	M	f	{"day": 5, "year": 1908, "month": 10}	{"day": 5, "year": 1975, "month": 10}	Ushigome, Tokyo, Japan	Shinjuku, Tokyo, Japan	\N	{"original_name": "&#28165;&#27700; &#23558;&#22827;"}
b8fae912-626e-4e22-aac4-10062bd7082f	Emi	Ito	F	f	{"day": 1, "year": 1941, "month": 4}	{"day": 15, "year": 2012, "month": 6}	Tokoname, Chita, Aichi, Japan	\N	\N	{"birth_name": "Hideyo Ito (伊藤 日出代)", "original_name": "伊藤エミ"}
7991849b-aa0b-4efd-9759-dcc4ff87ceb1	Hiroshi	Inagaki	M	t	{"day": 30, "year": 1905, "month": 12}	{"day": 21, "year": 1980, "month": 5}	Komagome Sendagaya, Hongo, Tokyo, Japan	\N	{"Akihiro Azuma (&#26481; &#26126;&#28009;)","Kinpachi Kahijara (&#26806;&#21407; &#37329;&#20843;)"}	{"birth_name": "Hiroshijiro Inagaki (&#31282;&#22435; &#28009;&#20108;&#37070;)", "original_name": "&#31282;&#22435; &#28009;"}
bf17ae68-1ab5-48b3-93f8-12876984d814	Sachio	Sakai	M	t	{"day": 8, "year": 1925, "month": 9}	{"day": 11, "year": 1998, "month": 3}	Tokyo, Japan	\N	\N	{"birth_name": "Yukio Abe (&#38463;&#37096; &#24184;&#30007;)", "original_name": "&#22586; &#24038;&#21315;&#22827;"}
34de1ef2-9428-4c7e-8512-5683f7cced38	Hiroshi	Koizumi	M	t	{"day": 12, "year": 1926, "month": 8}	{"day": 31, "year": 2015, "month": 5}	Kamakura, Kanagawa, Japan	\N	\N	{"original_name": "&#23567;&#27849; &#21338;"}
fb14ed7b-7b9e-42da-85bc-5e88f6d86e1c	Kenji	Sahara	M	t	{"day": 14, "year": 1932, "month": 5}	\N	Kawasaki, Kanagawa, Japan	\N	\N	{"birth_name": "Masayoshi Kato (&#21152;&#34276; &#27491;&#22909;)", "original_name": "&#20304;&#21407; &#20581;&#20108;"}
67eeac93-8584-4ffd-a380-2ef1dbc83ee2	Yoshio	Kosugi	M	t	{"day": 15, "year": 1903, "month": 9}	{"day": 12, "year": 1968, "month": 3}	Nikko, Kamitsuga, Tochigi, Japan	\N	\N	{"original_name": "&#23567;&#26441; &#32681;&#30007;"}
6082d456-e1d7-43de-8174-148d1a2b09c0	Nadao	Kirino	M	t	{"day": 24, "year": 1932, "month": 11}	\N	Matsuyama, Ehime, Japan	\N	\N	{"original_name": "&#26704;&#37326; &#27915;&#38596;"}
101695ef-b3a1-4aab-a52b-95f52085af37	Nobuko	Otowa	F	t	{"day": 1, "year": 1924, "month": 10}	{"day": 22, "year": 1993, "month": 12}	Yonago, Saihaku, Tottori, Japan	\N	\N	{"birth_name": "Nobuko Kaji (&#21152;&#27835; &#20449;&#23376;)", "original_name": "&#20057;&#32701; &#20449;&#23376;"}
4aac5e75-0c01-418b-98fb-17d3f7138f85	Ikio	Sawamura	M	t	{"day": 4, "year": 1905, "month": 9}	{"day": 20, "year": 1975, "month": 9}	Tochigi, Japan	\N	\N	{"birth_name": "Shizuo Okabe (&#23713;&#37096; &#38745;&#38596;)", "original_name": "&#27810;&#26449; &#12356;&#12365;&#38596;"}
db1ce840-a3bc-4f58-8caf-5d2bcf272892	Keiko	Sata	F	t	{"day": 9, "year": 1941, "month": 6}	\N	\N	\N	\N	{"original_name": "&#20304;&#22810; &#22865;&#23376;"}
15b76bdf-bf34-413c-8726-cc8c54c87b9a	So	Yamamura	M	t	{"day": 24, "year": 1910, "month": 2}	{"day": 26, "year": 2000, "month": 5}	Tenri, Nara, Japan	Nakano, Tokyo, Japan	\N	{"birth_name": "Hirosada Koga (&#21476;&#36032; &#23515;&#23450;)", "original_name": "&#23665;&#26449; &#32880;"}
f58f875c-2183-462f-9ef9-d34c20bd5748	Miki	Yashiro	F	t	{"year": 1943}	\N	Yokohama, Kanagawa, Japan	\N	\N	{"birth_name": "Mikiko Yamada (&#23665;&#30000; &#32654;&#32000;&#23376;)", "original_name": "&#20843;&#20195; &#32654;&#32000;"}
acb4f84a-b52b-455d-a49a-65bc1d73dbe6	Jojiro	Okami	M	t	{"day": 31, "year": 1918, "month": 10}	{"day": 11, "year": 2003, "month": 12}	Osaka, Japan	\N	\N	{"original_name": "&#19992;&#32654;&#19976;&#20108;&#37070;"}
d85dc51d-4970-45b8-8b69-8472f0099fcb	Haruya	Sakamoto	M	t	{"day": 23, "year": 1928, "month": 8}	\N	\N	\N	\N	{"original_name": "&#22338;&#26412; &#26228;&#21705;"}
b53e5364-0ae6-4a10-b2d2-d41e6c87bd49	Minoru	Ito	M	t	{"day": 13, "year": 1928, "month": 3}	\N	Chiba, Japan	\N	\N	{"original_name": "&#20234;&#34276; &#23455;"}
3e42b352-0c52-4e39-b028-7b5a8b45e415	Yasuhiko	Saijo	M	t	{"day": 20, "year": 1939, "month": 2}	\N	Kagurazaka, Shinjuku, Tokyo, Japan	\N	\N	{"original_name": "&#35199;&#26781; &#24247;&#24422;"}
10af34fa-1751-4bfb-8950-3bd3667cc03f	Masaki	Shinohara	M	t	{"day": 1, "year": 1927, "month": 1}	\N	\N	\N	\N	{"original_name": "&#31712;&#21407; &#27491;&#35352;"}
914bfc59-ae69-495a-9a25-b1138de87bb0	Shigeaki	Hidaka	M	f	{"day": 30, "year": 1916, "month": 7}	\N	Miyazaki, Japan	\N	\N	{"original_name": "&#26085;&#39640; &#32321;&#26126;"}
701ee638-17cf-45b4-8815-95f87d4caf9a	Yumi	Ito	F	f	{"day": 1, "year": 1941, "month": 4}	{"day": 18, "year": 2016, "month": 5}	Tokoname, Chita, Aichi, Japan	\N	\N	{"birth_name": "Tsukiko Ito (伊藤 月子)", "original_name": "伊藤ユミ"}
c6877155-e133-42c0-874b-1aba9fd78b16	Tomoyuki	Tanaka	M	t	{"day": 26, "year": 1910, "month": 4}	{"day": 2, "year": 1997, "month": 4}	Kashiwara, Osaka, Japan	\N	\N	{"original_name": "&#30000;&#20013; &#21451;&#24184;"}
fae6c562-be36-496b-acdb-889a433773cc	Setsuko	Wakayama	F	t	{"day": 7, "year": 1929, "month": 6}	{"day": 9, "year": 1985, "month": 5}	Meguro, Tokyo, Japan	Chofu, Tokyo, Japan	\N	{"birth_name": "Setsuko Sakazume (&#22338;&#29226; &#12475;&#12484;&#23376;)", "original_name": "&#33509;&#23665; &#12475;&#12484;&#23376;"}
43f92b30-e8dc-496c-836f-a39ec34ce058	Kunio	Miyauchi	M	t	{"day": 16, "year": 1932, "month": 2}	{"day": 27, "year": 2006, "month": 11}	Setagaya, Tokyo, Japan	Fuchu, Tokyo, Japan	\N	{"birth_name": "Kokuro Miyauchi (&#23470;&#20869; &#22269;&#37070;)", "original_name": "&#23470;&#20869; &#22283;&#37070;"}
040d7f31-5c23-49df-9b69-d3fb78b6d93f	Tetsu	Nakamura	M	t	{"day": 19, "year": 1908, "month": 9}	{"day": 3, "year": 1992, "month": 8}	Vancouver, British Columbia, Canada	\N	\N	{"birth_name": "Satoshi Nakamura (&#20013;&#26449; &#21746;)", "original_name": "&#20013;&#26449; &#21746;"}
1cfeedcd-f22a-4d2a-9858-491a773d65ad	Yutaka	Sada	M	t	{"day": 30, "year": 1922, "month": 3}	\N	Sendagi, Hongo, Tokyo, Japan	\N	\N	{"original_name": "&#20304;&#30000; &#35914;"}
11865fca-5abe-4412-a3c3-be4e82245730	Haruko	Sugimura	F	t	{"day": 6, "year": 1906, "month": 1}	{"day": 4, "year": 1997, "month": 4}	Hiroshima, Japan	Bunkyo, Tokyo, Japan	\N	{"birth_name": "Haruko Nakano (&#20013;&#37326; &#26149;&#23376;)", "original_name": "&#26441;&#26449; &#26149;&#23376;"}
7890926d-3000-43b1-9be4-272609b3cca7	Hideyo	Amamoto	M	t	{"day": 2, "year": 1926, "month": 1}	{"day": 23, "year": 2003, "month": 3}	Wakamatsu, Fukuoka, Japan	Wakamatsu, Fukuoka, Japan	{"Eisei Amamoto (&#22825;&#26412; &#33521;&#19990;)"}	{"original_name": "&#22825;&#26412; &#33521;&#19990;"}
3254e908-84ac-4e17-a4aa-36858e3c0942	Kenichi	Enomoto	M	t	{"day": 11, "year": 1904, "month": 10}	{"day": 7, "year": 1970, "month": 1}	Aoyama, Akasaka, Tokyo, Japan	\N	\N	{"original_name": "&#27022;&#26412; &#20581;&#19968;"}
e230df43-9ff7-46ea-8e2a-a1f31a2b3204	Goro	Mutsumi	M	t	{"day": 11, "year": 1934, "month": 9}	\N	Higashi-Nada, Kobe, Hyogo, Japan	\N	\N	{"birth_name": "Seiji Nakanishi (&#20013;&#35199; &#28165;&#20108;)", "original_name": "&#30566; &#20116;&#26391;"}
37f86cbf-f363-4661-a911-94a2505f0da0	Jun	Funato	M	t	{"day": 26, "year": 1938, "month": 11}	\N	Wakayama, Japan	\N	\N	{"birth_name": "Tsunetaka Nishina (&#20161;&#31185; &#24120;&#38534;)", "original_name": "&#33337;&#25144; &#38918;"}
c9c178e8-1d9e-410e-af95-01a1cbfda822	William	Hodgson	M	t	{"day": 15, "year": 1877, "month": 11}	{"year": 1918, "month": 4}	Blackmore End, Essex, England	Ypres, Belgium	\N	{"japanese_name": "&#12454;&#12452;&#12522;&#12450;&#12512;&#12539;&#12507;&#12540;&#12503;&#12539;&#12507;&#12472;&#12473;&#12531;"}
8354c6a4-fa6b-4ac6-8f8a-d29ff1d1d3bb	Heihachiro	Okawa	M	t	{"day": 9, "year": 1905, "month": 9}	{"day": 27, "year": 1971, "month": 5}	Saitama, Japan	\N	{"Henry Okawa (&#12504;&#12531;&#12522;&#12540;&#22823;&#24029;)"}	{"original_name": "&#22823;&#24029; &#24179;&#20843;&#37070;"}
415eddaf-1711-4795-9381-bc001c89b0a7	Naoya	Kusakawa	M	t	{"day": 11, "year": 1929, "month": 6}	\N	Manchuria	\N	\N	{"original_name": "&#33609;&#24029; &#30452;&#20063;"}
f9a23daa-fab8-418d-90f0-30a195ca171d	Yoshio	Katsube	M	t	{"day": 19, "year": 1934, "month": 3}	\N	Ota, Shimane, Japan	\N	\N	{"original_name": "&#21213;&#37096; &#32681;&#22827;"}
2e3fbeb0-3e78-49ba-8cc1-7172e66b26f9	Gen	Shimizu	M	t	{"day": 1, "year": 1907, "month": 1}	{"day": 20, "year": 1972, "month": 12}	Matsunaga, Kanda, Tokyo, Japan	\N	\N	{"original_name": "&#28165;&#27700; &#20803;"}
c0aaff10-a67a-4304-a3c3-875a00348870	Junichiro	Mukai	M	t	{"day": 4, "year": 1927, "month": 7}	\N	Shibuya, Tokyo, Japan	\N	\N	{"original_name": "&#21521;&#20117; &#28147;&#19968;&#37070;"}
0b33ac7b-829f-4140-b760-74806280cf6a	Hisaya	Ito	M	t	{"day": 7, "year": 1924, "month": 8}	{"year": 2005}	Kobe, Hyogo, Japan	\N	\N	{"birth_name": "Naoya Ito (&#20234;&#34276; &#23578;&#20063;)", "original_name": "&#20234;&#34276; &#20037;&#21705;"}
36234a9f-5c59-4d3a-b25e-4428d8fe1472	Sanezumi	Fujimoto	M	t	{"day": 15, "year": 1910, "month": 7}	{"day": 2, "year": 1979, "month": 5}	Ryojun, Manchuria	\N	\N	{"original_name": "&#34276;&#26412; &#30495;&#28548;"}
20079bf2-7dc2-4e24-83bc-16f43af26cc6	Minoru	Chiaki	M	t	{"day": 28, "year": 1917, "month": 4}	{"day": 1, "year": 1999, "month": 11}	Onnenai, Nakagawa, Hokkaido, Japan	Fuchu, Tokyo, Japan	\N	{"birth_name": "Katsuji Sasaki (&#20304;&#12293;&#26408; &#21213;&#27835;)", "original_name": "&#21315;&#31179; &#23455;"}
12f88b8e-e9ba-4771-9c4d-786dc69c24af	Yuji	Koseki	M	t	{"day": 11, "year": 1909, "month": 8}	{"day": 18, "year": 1989, "month": 8}	Fukushima, Japan	\N	\N	{"original_name": "&#21476;&#38306; &#35029;&#32780;"}
d9b9fe70-61d5-477e-b927-453ab57591c9	Haruya	Kato	M	t	{"day": 22, "year": 1928, "month": 6}	\N	Minato, Tokyo, Japan	\N	\N	{"original_name": "&#21152;&#34276; &#26149;&#21705;"}
b41f2e59-2044-488c-b56f-8d3cfad0464c	Kozo	Nomura	M	t	{"day": 22, "year": 1931, "month": 12}	\N	Nerima, Toshima, Tokyo, Japan	\N	\N	{"birth_name": "Kazuhiro Osao (&#23614;&#26873; &#19968;&#28009;)", "original_name": "&#37326;&#26449; &#28009;&#19977;"}
4ba64419-409e-4f61-bd6e-d4a651cfe3e5	Akira	Kubo	M	t	{"day": 1, "year": 1936, "month": 12}	\N	Tokyo, Japan	\N	\N	{"birth_name": "Yasuyoshi Yamauchi (&#23665;&#20869; &#24247;&#20736;)", "original_name": "&#20037;&#20445; &#26126;"}
65a0d327-c858-475a-9648-63eb3eecd3a8	Keiju	Kobayashi	M	t	{"day": 23, "year": 1923, "month": 11}	{"day": 16, "year": 2010, "month": 9}	Murota, Gunma, Japan	Minato, Tokyo, Japan	\N	{"original_name": "&#23567;&#26519; &#26690;&#27193;"}
737e6959-4253-4ff2-abff-b6da339f2774	Ryo	Ikebe	M	t	{"day": 11, "year": 1918, "month": 2}	{"day": 8, "year": 2010, "month": 10}	Omori, Tokyo, Japan	Tokyo, Japan	\N	{"original_name": "&#27744;&#37096; &#33391;"}
63df9c5e-35b7-4e72-9e6f-4bb8216f7842	Yuriko	Hoshi	F	t	{"day": 6, "year": 1943, "month": 12}	\N	Kajicho, Chiyoda, Tokyo, Japan	\N	\N	{"original_name": "&#26143; &#30001;&#37324;&#23376;"}
c0eeeca2-2862-4a6f-bf5b-66920a8172a8	Nobuo	Nakamura	M	t	{"day": 14, "year": 1908, "month": 9}	{"day": 5, "year": 1991, "month": 7}	Otaru, Hokkaido, Japan	Tokyo, Japan	\N	{"original_name": "&#20013;&#26449; &#20280;&#37070;"}
9bf7c6b0-5a5f-485d-80e1-4fe6a1241bfd	Momoko	Kochi	F	t	{"day": 7, "year": 1932, "month": 3}	{"day": 5, "year": 1998, "month": 11}	Yunaka, Taito, Tokyo, Japan	Hiroo, Shibuya, Tokyo, Japan	\N	{"birth_name": "Momoko Okochi (&#22823;&#27827;&#20869; &#26691;&#23376;)", "original_name": "&#27827;&#20869; &#26691;&#23376;"}
6ec04ee3-d9f9-4d8b-91e2-ab10ae2e9d48	Hiroshi	Tachikawa	M	t	{"day": 7, "year": 1931, "month": 3}	\N	Ogimachi, Tama, Tokyo, Japan	\N	\N	{"birth_name": "Yoichi Tachikawa (&#22826;&#20992;&#24029; &#27915;&#19968;)", "original_name": "&#22826;&#20992;&#24029; &#23515;"}
2ffd8877-261d-408c-97df-97bd6eb5748d	Mitsuko	Kusabue	F	t	{"day": 22, "year": 1933, "month": 10}	\N	Yokohama, Kanagawa, Japan	\N	\N	{"original_name": "&#33609;&#31515; &#20809;&#23376;"}
e4fc3ee2-b54f-4ec0-8a84-64352507c5de	Shigeru	Mori	M	f	\N	\N	\N	\N	\N	{"original_name": "&#26862;&#33538;"}
2caacc76-1f58-43ec-867c-ea717b8db1fb	Akihiko	Arakawa	M	f	\N	\N	\N	\N	\N	\N
f298c956-ac3a-4d29-b92b-462c16b833e1	Shunro	Oshikawa	M	t	{"day": 21, "year": 1876, "month": 3}	{"day": 16, "year": 1914, "month": 11}	Matsuyama, Ehime, Japan	Tokyo, Japan	\N	{"birth_name": "Masanori Oshikawa (&#25276;&#24029; &#26041;&#23384;)", "original_name": "&#25276;&#24029; &#26149;&#28010;"}
65171b44-fd3a-4948-9613-3f7206141774	Hideo	Shibuya	M	t	{"day": 20, "year": 1928, "month": 2}	\N	Tokyo, Japan	\N	\N	{"original_name": "&#28171;&#35895; &#33521;&#30007;"}
b883c489-0fe7-4165-86a4-49b531a28c37	Rinsaku	Ogata	M	t	{"day": 6, "year": 1925, "month": 1}	\N	\N	\N	\N	{"original_name": "&#32210;&#26041; &#29136;&#20316;"}
954bb729-459b-4676-b11b-912a33d3ca6d	Yukihiko	Gondo	M	t	\N	\N	\N	\N	\N	{"original_name": "&#27177;&#34276; &#24184;&#24422;"}
6de27671-6ff7-4603-beb5-1d683c42c4c2	Shigeki	Ishida	M	t	{"day": 17, "year": 1924, "month": 3}	{"year": 1997}	Kanazawa, Ishikawa, Japan	\N	\N	{"original_name": "&#30707;&#30000; &#33538;&#27193;"}
f38a2a42-a836-4c62-a1d5-265cba51076b	Keiji	Sakakida	M	t	{"day": 15, "year": 1900, "month": 1}	{"unknown": 1}	Omagari, Senboku, Akita, Japan	\N	\N	{"original_name": "&#27018;&#30000; &#25964;&#20108;"}
b08c8645-13e0-4392-b01e-3d1d069d60ae	Fuminto	Matsuo	M	t	{"day": 6, "year": 1916, "month": 8}	{"unknown": 1}	Higashi, Yokohama, Kanagawa, Japan	\N	\N	{"original_name": "&#26494;&#23614; &#25991;&#20154;"}
23034690-67d2-4b91-a857-a04f9f810deb	Sonosuke	Sawamura	M	t	{"day": 1, "year": 1918, "month": 7}	{"day": 3, "year": 1978, "month": 11}	Akakusa, Tokyo, Japan	\N	\N	{"original_name": "&#28580;&#26449; &#23447;&#20043;&#21161;"}
60c38e10-e1ed-46f5-b167-2938649e4503	Ikuma	Dan	M	t	{"day": 17, "year": 1924, "month": 4}	{"day": 17, "year": 2001, "month": 5}	Yotsuya, Tokyo, Japan	Suzhou, Jiangsu, China	\N	{"original_name": "&#22296; &#20234;&#29590;&#30952;"}
fe24405b-2c4d-479e-8f0c-0233a656f259	Harold	Conway	M	t	{"day": 24, "year": 1911, "month": 5}	{"year": 1996}	Pennsylvania, United States	Japan	\N	{"japanese_name": "&#12495;&#12525;&#12523;&#12489;&#12539;S&#12539;&#12467;&#12531;&#12454;&#12455;&#12452;"}
68f3c5f0-720d-4047-afd0-8bcdf0e89892	Ganjiro	Nakamura	M	t	{"day": 17, "year": 1902, "month": 2}	{"day": 13, "year": 1983, "month": 4}	Osaka, Japan	\N	\N	{"birth_name": "Yoshio Hayashi (&#26519;&#22909;&#38596;)", "original_name": "&#20013;&#26449;&#40200;&#27835;&#37070;"}
19291744-943e-4d56-a006-f82021b01e1a	Ichiro	Arishima	M	t	{"day": 1, "year": 1916, "month": 3}	{"day": 20, "year": 1987, "month": 7}	Nagoya, Aichi, Japan	\N	\N	{"birth_name": "Tadao Oshima (&#22823;&#23798; &#24544;&#38596;)", "original_name": "&#26377;&#23798; &#19968;&#37070;"}
f30c8c01-5689-44b7-9009-468f0165763b	Kyoko	Anzai	F	t	{"day": 27, "year": 1934, "month": 9}	{"day": 28, "year": 2002, "month": 12}	Osaka, Japan	Shibuya, Tokyo, Japan	\N	{"original_name": "&#23433;&#35199; &#37111;&#23376;"}
478bc636-02cd-42e9-901c-a3acb24df07e	Somesho	Matsumoto	M	t	{"day": 20, "year": 1903, "month": 3}	{"day": 12, "year": 1985, "month": 8}	Ushigome, Tokyo, Japan	Nishi, Shinjuku, Tokyo, Japan	\N	{"birth_name": "Hachiro Nomura (&#37326;&#26449; &#20843;&#37070;)", "original_name": "&#26494;&#26412; &#26579;&#21319;"}
5dab35d1-8242-4af3-831c-2cb48b954f61	Keisuke	Yamada	M	t	\N	\N	\N	\N	\N	{"original_name": "&#23665;&#30000; &#22317;&#20171;"}
cae2fb10-3188-41b9-9a7f-d23a5d8f9eb2	Junpei	Natsuki	M	t	{"day": 15, "year": 1918, "month": 6}	{"day": 21, "year": 2010, "month": 2}	Kitakyushu, Fukuoka, Japan	\N	\N	{"original_name": "&#22799;&#26408; &#38918;&#24179;"}
2ebd5427-97aa-4b77-b5af-66a55ff46fc4	Seishiro	Kuno	M	t	{"day": 18, "year": 1940, "month": 4}	\N	Shizuoka, Japan	\N	\N	{"original_name": "&#20037;&#37326; &#24449;&#22235;&#37070;"}
2f955981-68a8-4db4-9d3a-3f0f81321ff0	Yukiko	Kobayashi	F	t	{"day": 6, "year": 1946, "month": 10}	\N	Tokyo, Japan	\N	\N	{"original_name": "&#23567;&#26519; &#22805;&#23696;&#23376;"}
9c7cc495-89cb-4892-8d6f-0308ac4b1c54	Kamatari	Fujiwara	M	t	{"day": 15, "year": 1905, "month": 1}	{"day": 21, "year": 1985, "month": 12}	Tokyo, Japan	\N	\N	{"original_name": "&#34276;&#21407; &#37340;&#36275;"}
54bbf86b-1738-4b48-a846-745cac5fd622	Koji	Furuhata	M	t	\N	\N	\N	\N	\N	{"original_name": "&#21476;&#30033; &#24344;&#20108;"}
505a2aab-1965-4e16-a6b4-697e14d85d1a	Akira	Sera	M	t	{"day": 14, "year": 1912, "month": 10}	{"unknown": 1}	Azino, Kojima, Okayama, Japan	\N	\N	{"birth_name": "Akira Watanabe (&#28193;&#36794; &#31456;)", "original_name": "&#28716;&#33391; &#26126;"}
06adecc6-cbbe-4893-a916-16e683448590	Yoshio	Tsuchiya	M	t	{"day": 18, "year": 1927, "month": 5}	\N	Yamanashi, Japan	\N	\N	{"original_name": "&#22303;&#23627; &#22025;&#30007;"}
ecb241cd-e5e8-4239-a084-3fc522475618	George	Furness	M	t	{"year": 1896}	{"day": 2, "year": 1985, "month": 4}	New Jersey, United States	\N	\N	{"japanese_name": "&#12472;&#12519;&#12540;&#12472;&#12539;A&#12539;&#12501;&#12449;&#12540;&#12493;&#12473;"}
bdd9d156-3b37-4094-b65a-162ce892674d	Eitaro	Ozawa	M	t	{"day": 27, "year": 1909, "month": 3}	{"day": 23, "year": 1988, "month": 4}	Tamura, Shiba, Tokyo, Japan	Zushi, Kanagawa, Japan	\N	{"original_name": "&#23567;&#27810; &#26628;&#22826;&#37070;"}
006a5098-4f81-40eb-8f8e-785e6f43a956	Toshiro	Mifune	M	t	{"day": 1, "year": 1920, "month": 4}	{"day": 24, "year": 1997, "month": 12}	Qingdao, China	Mitaka, Tokyo, Japan	\N	{"original_name": "&#19977;&#33337; &#25935;&#37070;"}
77eed290-8834-456e-90ef-0ca75ac07973	Eijiro	Tono	M	t	{"day": 17, "year": 1907, "month": 9}	{"day": 8, "year": 1994, "month": 9}	Tomioka, Kanra, Gunma, Japan	Kokubunji, Tokyo, Japan	\N	{"original_name": "&#26481;&#37326; &#33521;&#27835;&#37070;"}
858c1a73-ab59-4fc3-8d57-2219320bfdf7	Kingoro	Yanagiya	M	t	{"day": 28, "year": 1901, "month": 2}	{"day": 22, "year": 1972, "month": 10}	Tokyo, Japan	\N	\N	{"birth_name": "Keitaro Yamashita (&#23665;&#19979; &#25964;&#22826;&#37070;)", "original_name": "&#26611;&#23478; &#37329;&#35486;&#27004;"}
def945ba-826b-4d5a-b100-ce9eb2362805	Minoru	Takada	M	t	{"day": 20, "year": 1899, "month": 12}	{"day": 27, "year": 1977, "month": 12}	Higashinaruse, Ogachi, Akita, Japan	\N	\N	{"birth_name": "Noboru Takada (&#39640;&#30000; &#26119;)", "original_name": "&#39640;&#30000; &#31252;"}
16cf1b1e-dfd0-420d-a624-325b6287dd1a	Frankie	Sakai	M	t	{"day": 13, "year": 1929, "month": 2}	{"day": 10, "year": 1996, "month": 6}	Kagoshima, Japan	Minato, Tokyo, Japan	\N	{"birth_name": "Masatoshi Sakai (&#22586; &#27491;&#20426;)", "original_name": "&#12501;&#12521;&#12531;&#12461;&#12540;&#22586;"}
eb909bc3-8688-4b5d-91c7-bae649a84c2a	Masanari	Nihei	M	t	{"day": 4, "year": 1940, "month": 12}	\N	Nagatacho, Kojimachi, Tokyo, Japan	\N	\N	{"original_name": "&#20108;&#29942; &#27491;&#20063;"}
a860b944-2633-47f3-bea6-8f6a2dece2ff	Hideo	Sunazuka	M	t	{"day": 7, "year": 1932, "month": 8}	\N	Atami, Shizuoka, Japan	\N	\N	{"original_name": "&#30722;&#22618; &#31168;&#22827;"}
32b3608c-6052-4ea4-9f14-38fa182a0340	Shoji	Oki	M	t	{"day": 27, "year": 1936, "month": 9}	\N	Numazu, Shizuoka, Japan	\N	\N	{"original_name": "&#22823;&#26408; &#27491;&#21496;"}
2f7a44eb-826b-477e-973b-5c57a715b25a	Mitsuo	Tsuda	M	t	{"day": 13, "year": 1910, "month": 9}	{"unknown": 1}	Fukushima, Japan	\N	\N	{"original_name": "&#27941;&#30000; &#20809;&#30007;"}
92dd9d68-0b73-443a-8aae-f0e7bba34f32	Kamayuki	Tsubono	M	t	{"day": 26, "year": 1919, "month": 7}	{"unknown": 1}	\N	\N	\N	{"original_name": "&#22378;&#37326; &#37772;&#20043;"}
20f64b6e-c968-4cf2-b195-76561d8acea6	Soji	Ubukata	M	t	{"day": 29, "year": 1908, "month": 3}	{"unknown": 1}	Tokyo, Japan	\N	\N	{"original_name": "&#29983;&#26041; &#22766;&#20816;"}
fefa0ceb-89a5-4d79-8a4a-80dfb16238a0	Yutaka	Oka	M	t	{"day": 11, "year": 1925, "month": 7}	{"day": 27, "year": 2000, "month": 7}	Kyoto, Japan	\N	\N	{"original_name": "&#23713; &#35914;"}
e68b3a04-1efc-43ab-8bf3-1bf60eb72014	Keiko	Kondo	F	t	{"day": 18, "year": 1943, "month": 3}	\N	\N	\N	\N	{"original_name": "&#36817;&#34276; &#22317;&#23376;"}
885202f7-ebc0-41e6-91c8-761c1b65593a	Yutaka	Nakayama	M	t	{"day": 23, "year": 1939, "month": 9}	\N	Himeji, Hyogo, Japan	\N	\N	{"original_name": "&#20013;&#23665; &#35914;"}
060bffd0-c2bc-4a01-8928-e4921c6ea447	Kenzo	Tabu	M	t	{"day": 13, "year": 1914, "month": 8}	{"day": 19, "year": 1993, "month": 11}	Kyoto, Japan	\N	\N	{"birth_name": "Yasutaro Tabu (&#30000;&#27494; &#23433;&#22826;&#37070;)", "original_name": "&#30000;&#27494; &#35609;&#19977;"}
802c7416-8696-4075-a778-83314da7310d	Masao	Tamai	M	f	{"day": 3, "year": 1908, "month": 10}	{"day": 26, "year": 1997, "month": 5}	Matsuyama, Ehime, Japan	\N	\N	{"original_name": "&#29577;&#20117; &#27491;&#22827;"}
aa83b831-f8ba-42af-95d0-fab1c9755bbc	Minosuke	Yamada	M	t	{"day": 13, "year": 1893, "month": 11}	{"day": 3, "year": 1968, "month": 8}	Tokyo, Japan	\N	\N	{"original_name": "&#23665;&#30000; &#24051;&#20043;&#21161;"}
c83bbdef-93a5-45dd-a789-5d44400ab825	Sadamasa	Arikawa	M	t	{"day": 17, "year": 1925, "month": 6}	{"day": 22, "year": 2005, "month": 9}	Tokyo, Japan	Higashiizu, Kamo, Shizuoka, Japan	\N	{"original_name": "&#26377;&#24029; &#35998;&#26124;"}
ba785322-fe4d-459b-b926-9fb2ed0f34ef	Koreya	Senda	M	t	{"day": 15, "year": 1904, "month": 7}	{"day": 21, "year": 1994, "month": 12}	Tokyo, Japan	Minato, Tokyo, Japan	\N	{"birth_name": "Kunio Ito (&#20234;&#34276; &#22272;&#22827;)", "original_name": "&#21315;&#30000; &#26159;&#20063;"}
eac19d16-75cd-45f7-a3f3-0a033b4b5e08	Yoko	Tsukasa	F	t	{"day": 20, "year": 1934, "month": 8}	\N	Saihaku, Tottori, Japan	\N	\N	{"birth_name": "Yoko Shoji (&#24196;&#21496; &#33865;&#23376;)", "original_name": "&#21496; &#33865;&#23376;"}
0cd551b9-f7a4-4bdf-b0e5-050c835f1096	Jun	Tazaki	M	t	{"day": 28, "year": 1913, "month": 8}	{"day": 18, "year": 1985, "month": 10}	Aomori, Japan	Tokyo, Japan	\N	{"birth_name": "Minoru Tanaka (&#30000;&#20013;&#23455;)", "original_name": "&#30000;&#23822; &#28516;"}
c71be339-7ad0-4293-8ee9-3b26258c7f7a	Taro	Asahiyo	M	t	{"day": 13, "year": 1929, "month": 11}	{"day": 23, "year": 1988, "month": 10}	Tokunoshima, Kagoshima, Japan	\N	\N	{"birth_name": "Fumitoshi Yonekawa (&#31859;&#24029; &#25991;&#25935;)", "original_name": "&#26397;&#28526; &#22826;&#37070;"}
0887b3b0-a812-4501-8be9-2d25b4048d43	Osman	Yusef	M	t	{"day": 23, "year": 1920, "month": 5}	{"day": 29, "year": 1982, "month": 8}	Ottoman Empire	\N	{"Johnny Yusef"}	{"japanese_name": "&#12458;&#12473;&#12510;&#12531;&#12539;&#12518;&#12475;&#12501;"}
4d4125bc-22de-4f64-9844-720cd84d9a14	Jerry	Ito	M	t	{"day": 12, "year": 1927, "month": 7}	{"day": 8, "year": 2007, "month": 7}	New York, United States	Los Angeles, California, United States	\N	{"birth_name": "Gerald Tamekichi Ito", "japanese_name": "&#12472;&#12455;&#12522;&#12540;&#20234;&#34276;"}
fd1d5a32-95c6-45da-8b27-99e6f9b8b9af	Hiroshi	Hasegawa	M	t	{"day": 3, "year": 1928, "month": 1}	\N	Tokyo, Japan	\N	\N	{"original_name": "&#38263;&#35895;&#24029; &#24344;"}
ff76604e-909d-489b-8c32-64de3d04a0fc	Tadao	Takashima	M	t	{"day": 27, "year": 1930, "month": 7}	\N	Muko, Hyogo, Japan	\N	\N	{"original_name": "&#39640;&#23798; &#24544;&#22827;"}
975efb7b-e01c-4ca2-9c8d-6deaddcf6ade	Yoko	Fujiyama	F	t	{"day": 17, "year": 1941, "month": 12}	\N	Hakkei, Kanazawa, Yokohama, Kanagawa, Japan	\N	\N	{"original_name": "&#34276;&#23665; &#38525;&#23376;"}
d857a341-b082-4338-906c-f3ba566a9d3b	Russ	Tamblyn	M	t	{"day": 30, "year": 1934, "month": 12}	\N	Los Angeles, California, United States	\N	\N	{"birth_name": "Russell Irving Tamblyn", "japanese_name": "&#12521;&#12473;&#12539;&#12479;&#12531;&#12502;&#12522;&#12531;"}
839d802a-34c1-4258-a75a-2a5bbfe67afc	Kazuo	Hinata	M	t	{"day": 21, "year": 1918, "month": 7}	\N	Nihonbashi, Chuo, Tokyo, Japan	\N	\N	{"original_name": "&#26085;&#26041; &#19968;&#22827;"}
949e61ea-2ba5-475d-8491-e784144eaf71	Susumu	Kurobe	M	t	{"day": 22, "year": 1939, "month": 10}	\N	Kurobe, Toyama, Japan	\N	\N	{"birth_name": "Takashi Yoshimoto (&#21513;&#26412; &#38534;&#24535;)", "original_name": "&#40658;&#37096; &#36914;"}
91f549ac-d460-44e6-b2d3-70b96cb593de	Masao	Fukasawa	M	t	{"year": 1921}	{"year": 2000}	\N	\N	{"Little Man Ma-chan (&#23567;&#20154;&#12398;&#12510;&#12540;&#12481;&#12515;&#12531;)"}	{"original_name": "&#28145;&#27810; &#25919;&#38596;"}
e521b82f-a0e4-4d30-911f-92cba2058dfc	Kenjiro	Uemura	M	t	{"day": 3, "year": 1914, "month": 1}	{"day": 3, "year": 1979, "month": 4}	Shinjuku, Tokyo, Japan	\N	\N	{"original_name": "&#26893;&#26449; &#35609;&#20108;&#37070;"}
113749dd-9700-4434-b8d7-4c55a7f00aa7	Nakajiro	Tomita	M	t	{"day": 1, "year": 1911, "month": 11}	{"day": 15, "year": 1990, "month": 11}	Yotsuya, Tokyo, Japan	\N	\N	{"original_name": "&#23500;&#30000; &#20210;&#27425;&#37070;"}
33c417fc-2635-4667-aaa7-feab79073d9d	Choshiro	Ishii	M	f	{"day": 7, "year": 1918, "month": 6}	{"day": 26, "year": 1983, "month": 2}	Tokyo, Japan	\N	\N	{"original_name": "&#30707;&#20117; &#38263;&#22235;&#37070;"}
528d732d-4d4c-430f-92a0-07de1e0b311d	Tomohisa	Yano	M	f	\N	\N	\N	\N	\N	{"original_name": "矢野 友久"}
f79f33f2-2385-49c8-9c63-e6c118835713	Senkichi	Omura	M	t	{"day": 27, "year": 1922, "month": 4}	{"day": 24, "year": 1991, "month": 11}	Fukagawa, Tokyo, Japan	\N	\N	{"original_name": "&#22823;&#26449; &#21315;&#21513;"}
ba66d21c-9c9a-4290-848e-a89f3a2ce28d	Yumi	Shirakawa	F	t	{"day": 21, "year": 1936, "month": 10}	{"day": 14, "year": 2016, "month": 6}	Shinagawa, Tokyo, Japan	Tokyo, Japan	\N	{"birth_name": "Akiko Yamazaki (&#23665;&#23822; &#23433;&#22522;&#23376;)", "original_name": "&#30333;&#24029; &#30001;&#32654;"}
7e735ef6-b865-424d-9291-0387716327cb	Makoto	Sato	M	t	{"day": 18, "year": 1934, "month": 3}	{"day": 6, "year": 2012, "month": 12}	Kanzaki, Saga, Japan	Kawasaki, Japan	\N	{"original_name": "&#20304;&#34276; &#20801;"}
22c73667-bbd2-41e1-93ed-45913b29fe29	Kumi	Mizuno	F	t	{"day": 1, "year": 1937, "month": 1}	\N	Sanjo, Niigata, Japan	\N	\N	{"birth_name": "Maya Igarashi (&#20116;&#21313;&#23888; &#40635;&#32822;)", "original_name": "&#27700;&#37326; &#20037;&#32654;"}
235193ac-7eb5-4514-b03d-cefab039ed5f	Yu	Fujiki	M	t	{"day": 2, "year": 1931, "month": 3}	{"day": 19, "year": 2005, "month": 12}	Ebaramachi, Ebara, Tokyo, Japan	Chuo, Tokyo, Japan	\N	{"birth_name": "Yuzo Suzuki (&#37428;&#26408; &#24736;&#34101;)", "original_name": "&#34276;&#26408; &#24736;"}
5b57a4bc-e1db-447b-b698-812b1b6ff5e4	Koji	Tsuruta	M	t	{"day": 6, "year": 1924, "month": 12}	{"day": 16, "year": 1987, "month": 6}	Nishinomiya, Hyogo, Japan	\N	\N	{"birth_name": "Eiichi Ono (&#23567;&#37326; &#27054;&#19968;)", "original_name": "&#40372;&#30000; &#28009;&#20108;"}
8880384d-16f9-4e12-b9c2-708c2ecaa93a	Seizaburo	Kawazu	M	t	{"day": 30, "year": 1908, "month": 8}	{"day": 20, "year": 1983, "month": 2}	Nihonbashi, Tokyo, Japan	\N	\N	{"birth_name": "Seiichi Nakajima (&#20013;&#23798; &#35488;&#19968;)", "original_name": "&#27827;&#27941; &#28165;&#19977;&#37070;"}
6eeae332-74cd-43e3-a747-e0ab5d6d1f66	Ken	Uehara	M	t	{"day": 7, "year": 1909, "month": 11}	{"day": 23, "year": 1991, "month": 11}	Ushigome, Tokyo, Japan	\N	\N	{"birth_name": "Kiyoaki Ikehata (&#27744;&#31471; &#28165;&#20142;)", "original_name": "&#19978;&#21407; &#35609;"}
3b4d8cf3-372d-4180-a625-d7ece05d7d58	Kenichiro	Maruyama	M	t	{"day": 12, "year": 1938, "month": 7}	\N	\N	\N	\N	{"original_name": "&#20024;&#23665; &#35609;&#19968;&#37070;"}
ba096bb3-4c76-453a-8d6a-86a01d2e0337	Tadashi	Okabe	M	t	{"day": 11, "year": 1923, "month": 5}	\N	Saitama, Japan	\N	\N	{"original_name": "&#23713;&#37096; &#27491;"}
c21e21a8-e940-417c-982e-33aacb5e19a7	Yasuhisa	Tsutsumi	M	t	{"day": 30, "year": 1922, "month": 3}	{"unknown": 1}	Tokyo, Japan	\N	\N	{"original_name": "&#22564; &#24247;&#20037;"}
97fb5fee-4d35-45d7-8438-93a364a5135d	Miki	Sanjo	F	t	{"day": 25, "year": 1928, "month": 8}	{"day": 9, "year": 2015, "month": 4}	Kyoto, Japan	Tokyo, Japan	\N	{"original_name": "&#19977;&#26781; &#32654;&#32000;"}
7c32641a-4525-485a-aeb6-b7cdf4baf19e	Toshio	Kurosawa	M	t	{"day": 4, "year": 1944, "month": 2}	\N	Nishi, Yokohama, Kanagawa, Japan	\N	\N	{"original_name": "&#40658;&#27810; &#24180;&#38596;"}
177089db-5eef-4ab2-8d7a-cf11693545ca	Masanobu	Miyazaki	M	f	\N	\N	\N	\N	\N	{"original_name": "&#23470;&#23822;&#27491;&#20449;"}
f78c7a73-5c05-4dd1-b0a8-c6fdfbee3a3e	Shin	Otomo	M	t	{"day": 13, "year": 1919, "month": 4}	{"unknown": 1}	Akita, Japan	\N	\N	{"original_name": "&#22823;&#21451; &#20280;"}
86209caa-4d37-4745-be23-dbee24bf244a	Yoshibumi	Tajima	M	t	{"day": 4, "year": 1918, "month": 8}	{"day": 10, "year": 2009, "month": 9}	Kobe, Hyogo, Japan	\N	\N	{"original_name": "&#30000;&#23798; &#32681;&#25991;"}
1fa4a84a-c542-4bec-acae-dc5cfffcbd2b	Ko	Mishima	M	t	{"day": 20, "year": 1927, "month": 5}	\N	Nippori, Toshima, Tokyo, Japan	\N	\N	{"birth_name": "Katsuhiro Hase (&#38263;&#35895; &#21213;&#21338;)", "original_name": "&#19977;&#23798; &#32789;"}
ff867685-c261-4a94-94a3-e2ec307a8616	Misa	Uehara	F	t	{"day": 26, "year": 1937, "month": 3}	{"year": 2003}	Fukuoka, Japan	\N	\N	{"birth_name": "Misako Uehara (&#19978;&#21407; &#32654;&#20304;&#23376;)", "original_name": "&#19978;&#21407;&#32654;&#20304;"}
7c2734fd-8980-4ca8-b562-20f07dab5641	Chieko	Nakakita	F	t	{"day": 21, "year": 1926, "month": 5}	{"day": 13, "year": 2005, "month": 9}	Tokyo, Japan	Tokyo, Japan	\N	{"original_name": "&#20013;&#21271; &#21315;&#26525;&#23376;"}
c5411d00-f051-4771-80d5-40aa35ba7663	Setsuko	Hara	F	t	{"day": 17, "year": 1920, "month": 6}	{"day": 5, "year": 2015, "month": 9}	Hodogaya, Yokohama, Kanagawa, Japan	Kanagawa, Japan	\N	{"birth_name": "Masae Aida (&#20250;&#30000; &#26124;&#27743;)", "original_name": "&#21407; &#31680;&#23376;"}
770edee6-77a7-4d9f-99f0-427750ae7aa5	Takamaru	Sasaki	M	t	{"day": 30, "year": 1898, "month": 1}	{"day": 28, "year": 1986, "month": 12}	Kawakami, Hokkaido, Japan	Setagaya, Tokyo, Japan	\N	{"original_name": "&#20304;&#12293;&#26408; &#23389;&#20024;"}
5e2a0e1c-5085-493e-864d-a886ffa6eb1f	Obel	Wyatt	M	t	\N	\N	\N	\N	\N	{"japanese_name": "&#12458;&#12540;&#12505;&#12523;&#12539;&#12527;&#12452;&#12450;&#12483;&#12488;"}
ca42052c-b7db-4e90-a825-bf0afe11a5b9	Mie	Hama	F	t	{"day": 20, "year": 1943, "month": 11}	\N	Tokyo, Japan	\N	\N	{"original_name": "&#27996; &#32654;&#26525;"}
609b8ee2-5b44-481b-82e9-5fafb7403036	Tetsuko	Kobayashi	F	t	{"day": 12, "year": 1941, "month": 3}	{"day": 9, "year": 1994, "month": 12}	Tokyo, Japan	\N	\N	{"original_name": "&#23567;&#26519; &#21746;&#23376;"}
9e5948a3-3002-44bf-912e-5902e5f385f1	Shiro	Tsuchiya	M	t	{"day": 5, "year": 1901, "month": 1}	{"unknown": 1}	Akita, Japan	\N	{"Hirotoshi Tsuchiya (&#22303;&#23627; &#21338;&#25935;)"}	{"original_name": "&#22303;&#23627; &#35433;&#26391;"}
d08d501c-fb18-4360-8e59-9685b5ecead3	Akiko	Wakabayashi	F	t	{"day": 13, "year": 1939, "month": 12}	\N	Kitasen, Ota, Tokyo, Japan	\N	\N	{"original_name": "&#33509;&#26519; &#26144;&#23376;"}
d387c2a2-4b42-48ff-bf6c-22e7909b93c8	Akira	Tani	M	t	{"day": 22, "year": 1910, "month": 9}	{"day": 11, "year": 1966, "month": 8}	Osaka, Japan	Satoshihigashi, Komae, Kitatama, Tokyo, Japan	\N	{"original_name": "&#35895; &#26179;"}
6976faf1-cfe4-489a-9dd5-c76f1ecc969b	Arthur	Rankin	M	t	{"day": 19, "year": 1924, "month": 7}	{"day": 30, "year": 2014, "month": 1}	New York City, New York, United States	Harrington Sound, Bermuda	\N	{"japanese_name": "&#12450;&#12540;&#12469;&#12540;&#12539;&#12521;&#12531;&#12461;&#12531;"}
7102d855-7fc6-4668-b20e-38fe1e3705cf	Shizuko	Azuma	F	f	{"day": 22, "year": 1930, "month": 8}	{"unknown": 1}	Tokyo, Japan	\N	\N	{"original_name": "&#26481; &#38745;&#23376;"}
ba759075-8927-42c2-8da7-58086e6f1e27	Ken	Echigo	M	t	{"day": 2, "year": 1929, "month": 12}	{"unknown": 1}	Akita, Japan	\N	{"Kenzo Echigo (&#36234;&#24460; &#25010;&#19977;)"}	{"original_name": "&#36234;&#24460; &#25010;"}
0e2de731-55a7-44be-a0b3-8213183d631e	Takuzo	Kumagai	M	t	{"day": 3, "year": 1906, "month": 11}	{"unknown": 1}	Nagano, Japan	\N	{"Jiro Kumagai (&#29066;&#35895; &#20108;&#33391;)"}	{"original_name": "&#29066;&#35895; &#21331;&#19977;"}
69bf5524-7df6-4af9-bf93-b646a935ed53	Beverly	Maeda	F	t	{"day": 8, "year": 1948, "month": 8}	\N	Kamakura, Kanagawa, Japan	\N	\N	{"original_name": "&#21069;&#30000; &#32654;&#27874;&#37324;"}
89722c18-a818-49a3-8bea-27e46eaa150f	Keiko	Sawai	F	t	{"day": 2, "year": 1945, "month": 1}	\N	Osaka, Japan	\N	\N	{"original_name": "&#27810;&#20117; &#26690;&#23376;"}
18fd187f-354e-4318-b6f1-71ac2b35e169	Shigeo	Kato	M	t	{"day": 16, "year": 1925, "month": 6}	\N	Kamakura, Kanagawa, Japan	\N	\N	{"original_name": "&#21152;&#34276; &#33538;&#38596;"}
f41e7c82-78c1-40ed-b341-2e8d2e1b5df2	Shoichi	Hirose	M	t	{"day": 23, "year": 1918, "month": 6}	\N	\N	\N	\N	{"original_name": "&#24195;&#28716; &#27491;&#19968;"}
b86678a4-b0f5-477d-af53-af0dde7e60ef	Susumu	Fujita	M	t	{"day": 8, "year": 1912, "month": 1}	{"day": 23, "year": 1990, "month": 3}	Kurume, Fukuoka, Japan	Shibuya, Tokyo, Japan	\N	{"original_name": "&#34276;&#30000; &#36914;"}
41a0af3c-b4a2-443f-bdaa-7121df6fe056	Ayumi	Sonoda	F	t	{"day": 23, "year": 1933, "month": 9}	\N	Kanagawa, Japan	\N	\N	{"birth_name": "Yuko Iwatachi (&#23721;&#31435; &#20778;&#23376;)", "original_name": "&#22290;&#30000; &#12354;&#12422;&#12415;"}
f85684e5-7fc4-4c20-b88f-434069902fb7	Kyoko	Kagawa	F	t	{"day": 5, "year": 1931, "month": 12}	\N	Aso, Namekata, Ibaraki, Japan	\N	\N	{"birth_name": "Kyoko Makino (&#29287;&#37326; &#39321;&#23376;)", "original_name": "&#39321;&#24029; &#20140;&#23376;"}
f0cbc8fc-5aac-4278-8713-439075090442	Bokuzen	Hidari	M	t	{"day": 20, "year": 1894, "month": 2}	{"day": 26, "year": 1971, "month": 5}	Kitano, Kotesashi, Iruma, Saitama, Japan	\N	\N	{"birth_name": "Ichiro Mikashima (&#19977;&#12534;&#23798; &#19968;&#37070;)", "original_name": "&#24038; &#21340;&#20840;"}
b4904523-7ec4-4801-95ac-d5b65b69b168	Daisuke	Kato	M	t	{"day": 8, "year": 1911, "month": 2}	{"day": 31, "year": 1975, "month": 7}	Akasuka, Tokyo, Japan	\N	\N	{"birth_name": "Tokunosuke Kato (&#21152;&#34276; &#24499;&#20043;&#21161;)", "original_name": "&#21152;&#26481; &#22823;&#20171;"}
fea4a4e7-4d03-4b5b-add0-3a545a2ccb21	Tatsuo	Matsumura	M	t	{"day": 18, "year": 1914, "month": 12}	{"day": 18, "year": 2005, "month": 6}	Yokohama, Kanagawa, Japan	Shinjuku, Tokyo, Japan	\N	{"original_name": "&#26494;&#26449; &#36948;&#38596;"}
7b5238d1-ec51-47fa-ae20-8f15e501944f	Robert	Dunham	M	t	{"day": 6, "year": 1931, "month": 7}	{"day": 6, "year": 2001, "month": 8}	Portland, Maine, United States	Sarasota, Florida, United States	{"Dan Yuma (&#12480;&#12531;&#12539;&#12518;&#12510;)"}	{"japanese_name": "&#12525;&#12496;&#12540;&#12488;&#12539;&#12480;&#12531;&#12495;&#12512;"}
5e35fe94-1c41-4e60-a400-aa44c201deb1	Yosuke	Natsuki	M	t	{"day": 27, "year": 1936, "month": 2}	\N	Hachioji, Tokyo, Japan	\N	\N	{"birth_name": "Tamotsu Akuzawa (&#38463;&#20037;&#27810; &#26377;)", "original_name": "&#22799;&#26408; &#38525;&#20171;"}
ff1185b5-9359-441b-8c3d-cd6ea90d67b9	Norihei	Miki	M	t	{"day": 11, "year": 1924, "month": 4}	{"day": 25, "year": 1999, "month": 1}	Hama, Nihonbashi, Tokyo, Japan	\N	\N	{"birth_name": "Tadashi Tanuma (&#30000;&#27836; &#21063;&#23376;)", "original_name": "&#19977;&#26408; &#12398;&#12426;&#24179;"}
27bfdcc6-5f02-47fd-ae38-7ea8d9fac219	Tatsuya	Mihashi	M	t	{"day": 2, "year": 1923, "month": 11}	{"day": 15, "year": 2004, "month": 5}	Chuo, Tokyo, Japan	\N	\N	{"original_name": "&#19977;&#27211; &#36948;&#20063;"}
f02a3856-95fc-4e5b-8d58-9f733e3b2278	Hiroshi	Sekida	M	t	{"day": 17, "year": 1932, "month": 11}	\N	Setagaya, Tokyo, Japan	\N	\N	{"original_name": "&#38306;&#30000; &#35029;"}
9d5454d0-b6de-4b62-bf4e-da467bd6c53b	Akira	Wakamatsu	M	t	{"day": 12, "year": 1933, "month": 6}	\N	Fukushima, Japan	\N	\N	{"original_name": "&#33509;&#26494; &#26126;"}
e82833e4-7eee-4ef1-88e5-a285946593aa	Akio	Kusama	M	t	{"day": 7, "year": 1913, "month": 10}	{"unknown": 1}	\N	\N	\N	{"original_name": "&#33609;&#38291; &#29835;&#22827;"}
bee0c590-edb2-4f54-8d6a-7e105e2ed741	Kyoko	Ai	F	t	{"day": 2, "year": 1943, "month": 3}	\N	\N	\N	\N	{"birth_name": "Misho Tabuchi (&#30000;&#28181; &#32654;&#31911;)", "original_name": "&#24859; &#20140;&#23376;"}
2ef5fd75-6752-4e6b-ba59-02d2761e999e	Toru	Ibuki	M	t	{"day": 28, "year": 1940, "month": 1}	\N	Fukuoka, Japan	\N	\N	{"original_name": "&#20234;&#21561; &#24505;"}
707ffa12-afe9-4ea9-b269-5c40f47d0620	Haruo	Suzuki	M	t	{"day": 4, "year": 1926, "month": 10}	\N	Hongo, Tokyo, Japan	\N	\N	{"original_name": "&#37428;&#26408; &#27835;&#22827;"}
8e70dd9b-5105-49c4-9bdf-ba558a60f593	Koji	Uno	M	t	{"day": 21, "year": 1924, "month": 4}	{"day": 28, "year": 2003, "month": 7}	Omuta, Fukuoka, Japan	\N	\N	{"original_name": "&#23431;&#37326; &#26179;&#21496;"}
9615ed46-f166-4c51-b737-a25a0de312c3	Linda	Miller	F	t	{"day": 26, "year": 1947, "month": 12}	\N	Pennsylvania, United States	\N	\N	{"japanese_name": "&#12522;&#12531;&#12480;&#12539;&#12511;&#12521;&#12540;"}
acace893-b445-4425-98d9-09126f7dcbf6	Sokichi	Maki	M	f	\N	\N	\N	\N	\N	{"original_name": "&#29287; &#22766;&#21513;"}
c7826ac4-c962-4f2e-b62b-b0258eeadbee	Kazuji	Taira	M	f	\N	\N	\N	\N	\N	{"original_name": "&#24179; &#19968;&#20108;"}
c70d0b2e-8511-4bfb-8527-808b3fef2a09	Takeo	Kita	M	f	{"day": 9, "year": 1901, "month": 1}	{"day": 1, "year": 1979, "month": 9}	Osaka, Japan	\N	\N	{"original_name": "&#21271; &#29467;&#22827;"}
6ad606bd-e3cb-45c2-b8a6-bb068854ffd7	Hisashi	Shimonaga	M	f	{"day": 13, "year": 1912, "month": 12}	{"year": 1998}	Kumamoto, Japan	\N	\N	{"original_name": "&#19979;&#27704; &#23578;"}
84c442af-6bd6-4e53-93c6-f4b213175de4	Takeo	Murata	M	f	{"day": 17, "year": 1907, "month": 6}	{"day": 19, "year": 1994, "month": 7}	Shinagawa, Tokyo, Japan	\N	\N	{"original_name": "&#26449;&#30000; &#27494;&#38596;"}
ef73315d-624c-4436-a729-5e47d474365e	Toranosuke	Ogawa	M	f	{"day": 1, "year": 1897, "month": 12}	{"day": 29, "year": 1967, "month": 12}	Akasuka, Tokyo, Japan	Urawa, Saitama, Japan	\N	{"original_name": "&#23567;&#24029; &#34382;&#20043;&#21161;"}
97417c8f-8ba2-463d-a9d6-dac0810125be	Kiyoshi	Kimata	M	f	\N	\N	\N	\N	\N	{"original_name": "&#40232;&#30000; &#28165;"}
daffb7f5-4b0c-4e00-96c4-6ac19b15d22b	Kin	Sugai	F	f	{"day": 28, "year": 1928, "month": 2}	\N	Ushigome, Tokyo, Japan	\N	\N	{"original_name": "&#33733;&#20117; &#12365;&#12435;"}
0c704bd2-886c-4acc-8b83-f0b9b7ee8aac	Toyoaki	Suzuki	M	f	\N	\N	\N	\N	\N	{"original_name": "&#37428;&#26408;&#35914;&#26126;"}
600f3ec6-2ba2-4c6d-8cc1-01f4d625755b	Takeo	Oikawa	M	f	\N	\N	\N	\N	\N	{"original_name": "&#31496;&#24029;&#27494;&#22827;"}
f03e5540-5215-405b-8641-1b3f60ebe755	Kan	Hayashi	M	f	{"year": 1894}	{"unknown": 1}	Asakusa, Tokyo, Japan	\N	\N	{"original_name": "&#26519; &#24185;"}
3bd1857e-4894-4469-82da-e4f5f6c49a1a	Miyoko	Hoshino	F	f	\N	\N	\N	\N	\N	{"original_name": "&#26143;&#37326; &#32654;&#20195;&#23376;"}
922bb3b7-bee1-45e6-bcd0-524336747977	Mayuri	Mokusho	F	f	{"day": 7, "year": 1929, "month": 10}	\N	Tokyo, Japan	\N	\N	{"birth_name": "Kumiko Kitakumi (&#26408;&#21280; &#20037;&#32654;&#23376;)", "original_name": "&#26408;&#21280; &#12510;&#12518;&#12522;"}
65abafc9-9dce-440e-adcf-cd8ae728c7eb	Yukio	Kasama	M	f	\N	\N	\N	\N	\N	{"original_name": "&#31520;&#38291;&#38634;&#38596;"}
3ab19c1d-1525-46c0-a377-fe26be4e0950	Seiichi	Endo	M	f	\N	\N	\N	\N	\N	{"original_name": "&#36960;&#34276;&#31934;&#19968;"}
8bd05431-0f6f-47f7-b4c0-c928590e0f5d	Masaki	Onuma	M	f	\N	\N	\N	\N	\N	{"original_name": "&#22823;&#27836;&#27491;&#21916;"}
e12e2330-3a9a-489b-b6ed-7d9746a406d6	Masao	Fujiyoshi	M	f	{"year": 1913}	\N	Tokyo, Japan	\N	\N	{"original_name": "&#34276;&#22909; &#26124;&#29983;"}
5d149a9f-cd4e-4b01-91e5-934200b5dcdb	Teruaki	Abe	M	f	\N	\N	\N	\N	\N	{"original_name": "&#23433;&#20493;&#36637;&#26126;"}
90aad09a-2931-43e7-9f4d-1726e5f68685	Hajime	Koizumi	M	f	\N	\N	\N	\N	\N	{"original_name": "&#23567;&#27849;&#19968;"}
28c62b3a-217d-4a2f-aab1-3fd7817bd189	Reiko	Kaneko	F	f	\N	\N	\N	\N	\N	{"original_name": "&#20860;&#23376;&#29618;&#23376;"}
b8928aa8-991f-46b3-aca4-c72ba3656249	Toshio	Takashima	M	f	\N	\N	\N	\N	\N	{"original_name": "&#39640;&#23798;&#21033;&#38596;"}
a536e565-3ef4-4187-87d7-7b064855fddd	Toru	Watanabe	M	f	\N	\N	\N	\N	\N	{"original_name": "&#28193;&#36794; &#24505;"}
f8797cb2-6240-46d2-9772-5a58aeb0bc2e	Taiichi	Kankura	M	f	{"day": 30, "year": 1912, "month": 4}	\N	Tokyo, Japan	\N	\N	{"original_name": "&#23436;&#20489; &#27888;&#19968;"}
d99098d2-e43a-46a0-99aa-9458a2892bb1	Norio	Tone	M	f	\N	\N	\N	\N	\N	{"original_name": "&#20992;&#26681;&#32000;&#38596;"}
112a9c74-dd0f-4d1b-b020-18ad1062e48f	Yasuyoshi	Tajitsu	M	f	{"day": 19, "year": 1925, "month": 8}	{"year": 1982, "month": 6}	\N	\N	\N	{"original_name": "&#30000;&#23455; &#27888;&#33391;"}
f31c5c90-46a9-46c7-a071-06efd3e4955a	Leonard	Stanford	M	f	\N	\N	\N	\N	\N	{"japanese_name": "&#12524;&#12458;&#12490;&#12523;&#12489;&#12539;&#12473;&#12479;&#12531;&#12501;&#12457;&#12540;&#12489;"}
a78fc680-c144-4f9a-8e27-fc69b70a463f	Yoshio	Nishikawa	M	f	\N	\N	\N	\N	\N	{"original_name": "&#35199;&#24029;&#21892;&#30007;"}
293342a6-c449-4ec7-9103-b3091a184cd2	Kan	Ishii	M	f	{"day": 30, "year": 1921, "month": 3}	{"day": 24, "year": 2009, "month": 11}	Shitaya, Tokyo, Japan	\N	\N	{"original_name": "&#30707;&#20117; &#27475;"}
e77691f8-05d7-4ae8-a582-c51c41de9f0c	Osamu	Dazai	M	f	{"day": 19, "year": 1909, "month": 6}	{"day": 13, "year": 1948, "month": 6}	Kanagi, Kitatsugaru, Aomori, Japan	Kitatami, Tokyo, Japan	\N	{"birth_name": "Shuji Tsushima (&#27941;&#23798; &#20462;&#27835;)", "original_name": "&#22826;&#23472; &#27835;"}
d559ba92-0eba-4724-b9f3-08371868d9db	Douglas	Fein	M	f	\N	\N	\N	\N	\N	{"japanese_name": "&#12480;&#12464;&#12521;&#12473;&#12539;&#12501;&#12455;&#12540;&#12531;"}
3df58f3a-039b-45ab-bf42-d842796cb7fe	Kazuo	Yamada	M	f	{"day": 25, "year": 1919, "month": 3}	{"day": 29, "year": 2006, "month": 1}	Tokyo, Japan	\N	\N	{"original_name": "&#23665;&#30000; &#19968;&#22827;"}
5360ea2f-63f4-4453-9ffc-853586496732	Teruo	Aragaki	M	f	\N	\N	\N	\N	\N	{"original_name": "&#33618;&#22435; &#36637;&#38596;"}
79c3e233-566d-4d53-8fb0-87a1383ae3c8	Kipp	Hamilton	F	f	{"day": 16, "year": 1934, "month": 8}	{"day": 29, "year": 1981, "month": 1}	Los Angeles, California, United States	Los Angeles, California, United States	\N	{"birth_name": "Rita Marie Hamiton", "japanese_name": "&#12461;&#12483;&#12503;&#12539;&#12495;&#12511;&#12523;&#12488;&#12531;"}
8b35d3c7-019e-4371-b402-96f7c8cae0a9	Peter	Mann	M	f	\N	\N	\N	\N	\N	{"japanese_name": "&#12500;&#12540;&#12479;&#12540;&#12539;&#12510;&#12531;"}
3c600a20-5a6b-4578-9943-3e8836dd14d3	George	Wyman	M	f	\N	\N	\N	\N	\N	{"japanese_name": "&#12472;&#12519;&#12540;&#12472;&#12539;&#12527;&#12452;&#12510;&#12531;"}
6c891253-4c26-44fb-a952-fb1866d1819f	Toshio	Yasumi	M	f	{"day": 6, "year": 1903, "month": 4}	{"day": 22, "year": 1991, "month": 5}	Osaka, Japan	\N	\N	{"original_name": "&#20843;&#20303; &#21033;&#38596;"}
1e17ee46-4e58-4e9a-bf1b-5487910aae4e	Ross	Bennett	M	f	\N	\N	\N	\N	\N	{"japanese_name": "&#12525;&#12473;&#12539;&#12505;&#12493;&#12483;&#12488;"}
5a7a9af3-554a-451b-8835-78595116a9ff	Hiroshi	Nezu	M	f	\N	\N	\N	\N	\N	{"original_name": "&#26681;&#27941; &#21338;"}
8fbf0eb6-d46a-4f69-94ca-c3bfaf6b5e07	Fumio	Yanoguchi	M	f	\N	\N	\N	\N	\N	{"original_name": "&#30690;&#37326;&#21475;&#25991;&#38596;"}
78f3b649-dfe7-49bc-aeb4-d4e02a28e67c	Shoichi	Yoshizawa	M	f	\N	\N	\N	\N	\N	{"original_name": "&#21513;&#27810;&#26157;&#19968;"}
3dae06b9-b139-4c1d-b3db-e23ffe8d135c	Susumu	Utsumi	M	f	\N	\N	\N	\N	\N	{"original_name": "&#20869;&#28023; &#36914;"}
986d08ab-500a-4b71-a4e6-5cb2bcf6abb4	Kuichiro	Kishida	M	f	{"day": 18, "year": 1907, "month": 1}	{"day": 28, "year": 1996, "month": 10}	Kyoto, Japan	\N	\N	{"original_name": "&#23736;&#30000; &#20061;&#19968;&#37070;"}
a37c4464-16f1-4754-b563-e247908a185c	Hideo	Unagami	M	f	\N	\N	\N	\N	\N	{"original_name": "&#28023;&#19978; &#26085;&#20986;&#30007;"}
18459827-37dc-45ae-b244-2ddeba4ed9e9	Elise	Richter	F	f	\N	\N	\N	\N	\N	{"original_name": "&#12456;&#12522;&#12473;&#12539;&#12522;&#12463;&#12479;&#12540;"}
9da86934-7584-466a-84be-853819168103	Ryuzo	Kikushima	M	f	{"day": 28, "year": 1914, "month": 1}	{"day": 18, "year": 1989, "month": 3}	Kofu, Yamanashi, Japan	\N	\N	{"original_name": "&#33738;&#23798; &#38534;&#19977;"}
155ce21a-83a4-4059-bf88-08cf6d988842	Fumio	Sakashita	M	f	\N	\N	\N	\N	\N	{"original_name": "&#38263;&#35895;&#24029; &#24344;"}
aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Ryohei	Fujii	M	f	\N	\N	\N	\N	\N	{"original_name": "&#34276;&#20117; &#33391;&#24179;"}
6afdc4fe-fec9-4640-9299-40d56e5fb25a	Norikazu	Onda	M	f	\N	\N	\N	\N	\N	{"original_name": "&#38560;&#30000;&#32000;&#19968;"}
1e6ae6ba-b28a-4a9b-97a9-2374c016d267	Akio	Kobori	M	f	\N	\N	\N	\N	\N	{"original_name": "&#23567;&#22528;&#26126;&#30007;"}
8d818c87-fa3d-440c-9825-2def708d19cc	Kiyoshi	Shimizu	M	f	\N	\N	\N	\N	\N	{"original_name": "&#28165;&#27700;&#21916;&#20195;&#24535;"}
b4a497d1-74e0-4304-bc20-7a32275c73ab	Tsuruzo	Nishikawa	M	f	\N	\N	\N	\N	\N	{"original_name": "&#35199;&#24029;&#40372;&#19977;"}
36e34390-71ca-4e42-a28e-e6944cc7d582	Rokuro	Ishikawa	M	f	\N	\N	\N	\N	\N	{"original_name": "&#30707;&#24029;&#32209;&#37070;"}
475b78c0-45ad-46dc-8c99-b41a09ee2ec5	Kazue	Shiba	M	f	\N	\N	\N	\N	\N	{"original_name": "&#26031;&#27874;&#19968;&#32117;"}
a37d0291-2e69-40af-86f0-133859aaf1ff	Kisaku	Ito	M	f	{"day": 1, "year": 1899, "month": 8}	{"day": 31, "year": 1967, "month": 3}	Misaki, Kanda, Tokyo, Japan	\N	\N	{"original_name": "&#20234;&#34276; &#29113;&#26388;"}
f0248816-9020-47ff-a5f2-b77c0e43002c	Ko	Nishimura	M	f	{"day": 25, "year": 1923, "month": 1}	{"day": 15, "year": 1997, "month": 4}	Sapporo, Hokkaido, Japan	Kokubunji, Tokyo, Japan	\N	{"original_name": "&#35199;&#26449; &#26179;"}
a7476494-4b15-4fd8-93b4-4548ed8f0086	Shoshichi	Kojima	M	f	\N	\N	\N	\N	\N	{"original_name": "&#23567;&#23798;&#27491;&#19971;"}
479f2ab3-c3c5-4049-8b4e-99367ceb893d	Seiji	Onaka	M	f	{"day": 15, "year": 1934, "month": 12}	\N	Nara, Japan	\N	\N	{"original_name": "&#22823;&#20210; &#28165;&#27835;"}
46232c4d-423c-40eb-941d-087f6a1d0643	Hideo	Mihara	M	f	{"day": 9, "year": 1912, "month": 1}	{"day": 1, "year": 2003, "month": 11}	Asakasa, Tokyo, Japan	Tokyo, Japan	\N	{"original_name": "&#20304;&#20271; &#31168;&#30007;"}
08872122-2396-4e80-9a74-ef85447c4057	Mitsuo	Kaneko	M	f	\N	\N	\N	\N	\N	{"original_name": "&#37329;&#23376;&#20809;&#30007;"}
24651b22-cbb0-4472-9d73-c96ed96829d6	Choshichiro	Mikami	M	f	\N	\N	\N	\N	\N	{"original_name": "&#19977;&#19978;&#38263;&#19971;&#37070;"}
d901ee22-34f3-4dc0-8c93-2362b57387a2	Yo	Shiomi	M	f	{"day": 7, "year": 1895, "month": 7}	{"day": 1, "year": 1964, "month": 7}	Tokyo, Japan	Tokyo, Japan	\N	{"original_name": "&#27728;&#35211; &#27915;"}
301600d5-0f05-49a5-a23b-3f5751da8ac0	Hiroyuki	Wakita	M	f	\N	\N	\N	\N	\N	{"original_name": "&#33031;&#30000;&#21338;&#34892;"}
e5f1bba1-e4e2-452b-bb62-1747d34ca1e1	Eishu	Kin	M	f	\N	\N	\N	\N	\N	{"original_name": "&#37329;&#26628;&#29664;"}
e3ab3196-10d7-4e5e-83cd-2426353915bd	Ichiya	Aozora	M	f	{"day": 17, "year": 1932, "month": 7}	{"day": 23, "year": 1996, "month": 4}	Tokura, Nagano, Japan	\N	\N	{"birth_name": "Kihachiro Koitabashi (&#23567;&#26495;&#27211; &#21916;&#20843;&#37070;)", "original_name": "&#38738;&#31354; &#19968;&#22812;"}
b16d5b1e-8e3e-4814-9155-0a2eb9e06e3b	Shin	Watarai	M	f	{"day": 13, "year": 1918, "month": 12}	{"day": 28, "year": 2001, "month": 5}	Odate, Akita, Japan	\N	\N	{"original_name": "&#28193;&#20250; &#20280;"}
d1e73155-2bf5-4378-929f-277d92e5e2ae	Koichi	Iwashita	M	f	\N	\N	\N	\N	\N	{"original_name": "&#23721;&#19979; &#24195;&#19968;"}
00493c23-4851-4450-8d22-99eebd381727	Shinichi	Hoshi	M	f	{"day": 26, "year": 1926, "month": 9}	{"day": 30, "year": 1997, "month": 12}	Akebono, Hongo, Tokyo, Japan	Takanawa, Minato, Tokyo, Japan	\N	{"original_name": "&#26143; &#26032;&#19968;"}
387b5c1f-0e3a-4581-a4e1-26f64e412d52	Jun	Fujio	M	f	\N	\N	\N	\N	\N	{"original_name": "&#34276;&#23614;&#32020;"}
51ef93db-0b25-44e2-889d-b92768a49470	Kei	Beppu	M	f	\N	\N	\N	\N	\N	{"original_name": "&#21029;&#24220;&#21843;"}
7a593862-ec98-49bb-bd73-b35094f16971	Sei	Ikeno	M	f	{"day": 24, "year": 1931, "month": 2}	{"day": 13, "year": 2004, "month": 8}	Sapporo, Hokkaido, Japan	Tokyo, Japan	\N	{"original_name": "&#27744;&#37326; &#25104;"}
cd54d1db-167c-4361-98c4-6ebf75294ad0	Yoshitami	Kuroiwa	M	f	\N	\N	\N	\N	\N	{"original_name": "&#40658;&#23721; &#32681;&#27665;"}
c765ae89-2193-4416-a9d8-7136589d618c	Senya	Aozora	M	f	{"day": 28, "year": 1930, "month": 6}	{"day": 20, "year": 1991, "month": 6}	Kitakyushu, Fukuoka, Japan	\N	\N	{"birth_name": "Yoshihito Sakai (&#37202;&#20117; &#32681;&#20154;)", "original_name": "&#38738;&#31354; &#21315;&#22812;"}
1c30afb0-3f4d-4017-84fd-cb68e9a2e6f0	Toshiya	Ban	M	f	\N	\N	\N	\N	\N	{"original_name": "&#20276;&#21033;&#20063;"}
730e679a-bb91-449b-86fb-3384fc4b9720	Ken	Kuronuma	M	f	{"day": 1, "year": 1902, "month": 5}	{"day": 5, "year": 1985, "month": 7}	Yokohama, Kanagawa, Japan	\N	\N	{"original_name": "&#40658;&#27836; &#20581;"}
c75a73c4-ed27-468e-b065-ff5a764f80e3	Takehiko	Fukunaga	M	f	{"day": 19, "year": 1918, "month": 3}	{"day": 13, "year": 1979, "month": 8}	Futsukaichi, Chikushi, Fukuoka, Japan	Usuda, Minamisaku, Nagano, Japan	\N	{"original_name": "&#31119;&#27704; &#27494;&#24422;"}
89b2d627-c97d-45d4-9a49-2432c39b7fb4	Kyosuke	Kami	M	f	{"day": 3, "year": 1901, "month": 9}	{"day": 24, "year": 1981, "month": 3}	Otemachi, Hiroshima, Japan	\N	\N	{"original_name": "&#32025; &#24685;&#36628;"}
e14a8f59-a0e9-4286-be13-24559916e2c4	Kyoe	Hamagami	M	f	\N	\N	\N	\N	\N	{"original_name": "&#27996;&#19978;&#20853;&#34907;"}
9d1ccb86-2857-4a3a-b0e3-f30030053941	Takao	Saito	M	f	{"day": 5, "year": 1929, "month": 3}	{"day": 6, "year": 2014, "month": 12}	\N	\N	\N	{"original_name": "&#25998;&#34276; &#23389;&#38596;"}
48a7856e-e00d-410a-8dee-c9069575da5c	Shigekazu	Ikuno	M	f	{"day": 14, "year": 1925, "month": 1}	{"day": 26, "year": 2003, "month": 10}	Tokyo, Japan	\N	\N	{"original_name": "&#32946;&#37326; &#37325;&#19968;"}
d03c3fe8-39fa-4083-8e8a-85e033e6b92e	Yuriko	Hanabusa	F	f	{"day": 7, "year": 1900, "month": 3}	{"day": 7, "year": 1970, "month": 2}	Yoshiura, Hiroshima, Japan	\N	\N	{"birth_name": "Kesako Henmi (&#36920;&#35211; &#34952;&#35039;&#23376;)", "original_name": "&#33521; &#30334;&#21512;&#23376;"}
b9d6e433-dbac-4a1d-bb5b-1bdc316dfcb4	Takeji	Yamaguchi	G	f	\N	\N	\N	\N	\N	{"original_name": "&#23665;&#21475;&#20553;&#27835;"}
5f8cfa7b-c504-4902-bd08-e030af359323	Isamu	Ashida	M	f	\N	\N	\N	\N	\N	{"original_name": "&#33446;&#30000;&#21191;"}
b7285384-4240-4eaf-b9c0-ca8fcdc74233	Sadao	Bekku	M	f	{"day": 24, "year": 1922, "month": 5}	{"day": 12, "year": 2012, "month": 1}	Tokyo, Japan	\N	\N	{"original_name": "&#21029;&#23470; &#35998;&#38596;"}
1009b31a-0266-4068-a9b8-f4b58d423490	Shinichiro	Nakamura	M	f	{"day": 5, "year": 1918, "month": 3}	{"day": 25, "year": 1997, "month": 12}	Tokyo, Japan	\N	\N	{"original_name": "&#20013;&#26449; &#30495;&#19968;&#37070;"}
7782090a-df05-4bf5-8791-f8efac8951f4	Shuichi	Ihara	M	f	\N	\N	\N	\N	\N	{"original_name": "&#24245;&#21407; &#21608;&#19968;"}
7f06db03-42ca-4a84-bb01-a856eb036026	Yoyo	Miyata	M	f	{"day": 16, "year": 1915, "month": 2}	{"day": 11, "year": 1983, "month": 7}	Kumamoto, Japan	\N	{"Hitsujiyo Miyata (&#23470;&#30000; &#32650;&#23481;)"}	{"birth_name": "Nobuo Iwashita (&#23721;&#19979; &#20449;&#22827;)", "original_name": "&#23470;&#30000; &#27915;&#23481;"}
439b033b-b72a-4ed0-b2fd-c44468378bc0	Hiroko	Sakurai	F	f	{"day": 4, "year": 1946, "month": 3}	\N	Meguro, Tokyo, Japan	\N	\N	{"original_name": "&#26716;&#20117; &#28009;&#23376;"}
6032ee2a-e49e-43be-b727-dfda0a12c60f	Noriko	Sengoku	F	f	{"day": 29, "year": 1922, "month": 4}	{"day": 27, "year": 2012, "month": 12}	Komazawa, Ebara, Tokyo, Japan	\N	\N	{"original_name": "&#21315;&#30707; &#35215;&#23376;"}
1877d46d-9ace-4741-836c-0b03933c496d	Masami	Fukushima	M	f	{"day": 18, "year": 1929, "month": 2}	{"day": 9, "year": 1976, "month": 4}	Fengyuan, Sakhalin	\N	\N	{"original_name": "&#31119;&#23798; &#27491;&#23455;"}
07f8acfe-8d57-4c46-811c-8f499e27a989	Shoichi	Fujinawa	M	f	\N	\N	\N	\N	\N	{"original_name": "&#34276;&#32260;&#27491;&#19968;"}
8dddd2f4-0d44-40b8-ab2c-b927053f99bd	Keiko	Muramatsu	F	f	\N	\N	\N	\N	\N	{"original_name": "&#26449;&#26494;&#24693;&#23376;"}
07259617-c6ef-42ad-afac-b37d29f83e4e	Rokuro	Nishigaki	M	f	\N	\N	\N	\N	\N	{"original_name": "&#35199;&#22435;&#20845;&#37070;"}
06d3db81-7ec1-4f1c-9df6-e210dba769b2	Shunji	Kasuga	M	f	{"day": 14, "year": 1921, "month": 6}	{"unknown": 1}	Niigata, Japan	\N	\N	{"original_name": "&#26149;&#26085; &#20426;&#20108;"}
5358c92d-79db-46c1-83d5-ab6b1444506a	Ishiro	Honda	M	t	{"day": 7, "year": 1911, "month": 5}	{"day": 28, "year": 1993, "month": 2}	Asahi, Higashi-Tagawa, Yamagata, Japan	\N	\N	{"original_name": "&#26412;&#22810; &#29482;&#22235;&#37070;"}
64d0b412-18b4-495b-bf51-f8f59395c90b	Akira	Ifukube	M	t	{"day": 31, "year": 1914, "month": 5}	{"day": 8, "year": 2006, "month": 2}	Kushiro, Hokkaido, Japan	Meguro, Tokyo, Japan	\N	{"original_name": "&#20234;&#31119;&#37096; &#26157;"}
99d628a5-b63c-4bf4-ae4e-1290b618f02f	Tadao	Nakamaru	M	t	{"day": 31, "year": 1933, "month": 3}	{"day": 23, "year": 2009, "month": 4}	Adachi, Tokyo, Japan	Hongo, Bunkyo, Tokyo, Japan	\N	{"original_name": "&#20013;&#20024; &#24544;&#38596;"}
0bba81af-afab-4c75-b401-89844115a488	Kinuyo	Tanaka	F	t	{"day": 29, "year": 1909, "month": 11}	{"day": 21, "year": 1977, "month": 3}	Shimonoseki, Yamaguchi, Japan	Hongo, Bunkyo, Tokyo, Japan	\N	{"original_name": "&#30000;&#20013; &#32121;&#20195;"}
3b40b2fd-e981-4429-9a99-85cc2d357f50	Wataru	Konuma	M	f	\N	\N	\N	\N	\N	{"original_name": "&#23567;&#27836;&#28193;"}
e0d84176-6d73-4185-919e-ddb1fb22f400	Seiji	Hirano	M	f	\N	\N	\N	\N	\N	{"original_name": "&#24179;&#37326;&#28165;&#20037;"}
d031da60-ed80-44ee-b7e3-582c8d241aa6	Kenichiro	Tsunoda	M	f	{"day": 20, "year": 1919, "month": 5}	{"day": 7, "year": 1983, "month": 8}	\N	\N	\N	{"original_name": "&#35282;&#30000; &#20581;&#19968;&#37070;"}
6b8891db-a29b-4d5d-8635-c55f5c49e2ca	Masanao	Uehara	M	f	\N	\N	\N	\N	\N	{"original_name": "&#19978;&#21407;&#27491;&#30452;"}
d7c89e93-28a0-4ac3-833f-fea8014e11f4	Yoshie	Hotta	F	f	{"day": 7, "year": 1918, "month": 7}	{"day": 5, "year": 1998, "month": 9}	Takaoka, Toyama, Japan	\N	\N	{"original_name": "&#22528;&#30000; &#21892;&#34907;"}
2971159a-b9d5-4858-be61-23b3e5d754fb	Hajime	Izu	M	f	{"day": 6, "year": 1917, "month": 7}	{"year": 2005}	Tokyo, Japan	\N	\N	{"birth_name": "Hajime Watanabe (&#28193;&#37002; &#32903;)", "original_name": "&#20234;&#35910; &#32903;"}
88bd531f-1ba5-40c9-9e81-4bf05ee61fce	Hiromitsu	Mori	M	f	\N	\N	\N	\N	\N	{"original_name": "&#26862;&#24344;&#20805;"}
f6e9be35-e3c6-41c6-b7d1-076cede500a2	Hiroshi	Ueda	M	f	\N	\N	\N	\N	\N	{"original_name": "&#26893;&#30000; &#23515;"}
a1d942b8-21be-40de-be75-6a2d63a7d5f8	Koji	Shima	M	f	{"day": 16, "year": 1901, "month": 2}	{"day": 10, "year": 1986, "month": 9}	Nagasaki, Japan	\N	\N	{"original_name": "島 耕二"}
a5e97a63-5c15-41ba-85c9-71f2c7af4f01	Masaichi	Nagata	M	f	{"day": 21, "year": 1906, "month": 1}	{"day": 24, "year": 1985, "month": 10}	Kyoto, Japan	\N	\N	{"original_name": "永田 雅一"}
3d231f5f-cbda-4086-ac77-7403eac26317	Gentaro	Nakajima	M	f	{"day": 11, "year": 1929, "month": 2}	{"day": 7, "year": 1992, "month": 2}	Ota, Gunma, Japan	\N	\N	{"original_name": "中島 源太郎"}
b54ca5c3-b7bf-4ad3-a3eb-8b30339ffa54	Hideo	Oguni	M	f	{"day": 9, "year": 1904, "month": 7}	{"day": 6, "year": 1996, "month": 2}	Hachinohe, Aomori, Japan	\N	\N	{"original_name": "小国 英雄"}
fbe37cd8-26cf-4808-a578-a89f947afb36	Kimio	Watanabe	M	f	\N	\N	\N	\N	\N	{"original_name": "渡辺 公夫"}
5f8fa4d8-e602-4040-a06e-5644578718f6	Shigeo	Kanno	M	f	\N	\N	\N	\N	\N	{"original_name": "間野 重雄"}
72416ff4-fecf-4f02-9dd8-9936854ecef8	Norikazu	Nishii	M	f	\N	\N	\N	\N	\N	{"original_name": "西井 憲一"}
4cafc82d-fc63-42a5-bfc3-8894faa35e9f	Koichi	Kubota	M	f	\N	\N	\N	\N	\N	\N
fb0028bf-9f32-4434-896e-5bff5f4777fb	Seitaro	Omori	M	f	\N	\N	\N	\N	\N	{"original_name": "大森 盛太郎"}
fc69e110-1c48-4727-bde1-66e526756bcc	Toyo	Suzuki	M	f	\N	\N	\N	\N	\N	\N
7887e636-a848-430c-8436-293b47151fd0	Noriaki	Yuasa	M	f	{"day": 28, "year": 1933, "month": 9}	{"day": 14, "year": 2004, "month": 6}	Setagaya, Tokyo, Japan	\N	\N	{"original_name": "湯浅 憲明"}
f1a27fcf-fc61-4758-b3d7-dab10b1303e9	Nisan	Takahashi	M	f	{"day": 3, "year": 1926, "month": 2}	{"day": 5, "year": 2015, "month": 5}	Tamamura, Sawa, Gunma, Japan	\N	\N	{"birth_name": "Yukito Takahashi (高橋 幸人)", "original_name": "高橋 二三"}
114fce55-397a-4d9a-8e51-e6cf35909748	Nobuo	Munekawa	M	f	\N	\N	\N	\N	\N	{"original_name": "宗川 信夫"}
b322f19f-bf67-4e2c-8a50-476de85f537b	Akira	Inoue	M	f	{"year": 1929}	\N	Tokyo, Japan	\N	\N	{"original_name": "井上 章"}
740d232d-bd82-4b4a-b555-5e0d95ddf757	Toshikazu	Watanabe	M	f	\N	\N	\N	\N	\N	{"original_name": "渡辺 利一"}
df40aa02-23ca-407e-96ba-0aceacdbbdea	Yukio	Ito	M	f	\N	\N	\N	\N	\N	{"original_name": "伊藤 幸夫"}
1715410d-9cf0-4ecd-9857-4fb5f1bd4b97	Tadashi	Yamanouchi	M	f	{"day": 22, "year": 1927, "month": 8}	{"day": 20, "year": 1980, "month": 12}	Tokyo, Japan	\N	\N	{"original_name": "山内 正"}
09aaa976-2352-491d-b7d1-27bf5b0fd8c5	Tatsuji	Nakashizuka	M	f	\N	\N	\N	\N	\N	{"original_name": "中静 達治"}
334edb75-cdf8-4c2f-b22f-7697030a7701	Shigeo	Tanaka	M	f	\N	\N	\N	\N	\N	{"original_name": "田中 重雄"}
8f0d87f4-a164-4c5a-af72-3d85ba1449ee	Misao	Takahashi	M	f	{"day": 10, "year": 1905, "month": 1}	{"day": 3, "year": 1993, "month": 11}	Tokyo, Japan	\N	\N	{"original_name": "高橋 通夫"}
1ccef90e-d58d-4bbc-996a-08005f93cd9d	Tokuji	Shibata	M	f	\N	\N	\N	\N	\N	{"original_name": "柴田 篤二"}
3eb06002-3915-448e-a679-6fc538a995f1	Yukio	Okumura	M	f	\N	\N	\N	\N	\N	{"original_name": "奥村 幸雄"}
1c177c21-bbf9-4d93-9986-ec61102dbb87	Tsunekichi	Shibata	M	f	\N	\N	\N	\N	\N	{"original_name": "柴田 恒吉"}
5c532e64-32a4-4291-8b62-7ea8be62cc38	Chuji	Kinoshita	M	f	{"day": 9, "year": 1916, "month": 4}	\N	\N	\N	\N	{"original_name": "木下 忠司"}
f3d54e06-5646-4d23-8b5e-8346da366ce3	Hidemasa	Nagata	M	f	\N	\N	\N	\N	\N	{"original_name": "永田 秀雅"}
468ac861-fbe0-4d61-9c3f-1434781fe8fd	Akira	Uehara	M	f	\N	\N	\N	\N	\N	{"original_name": "上原 明"}
9565e97a-5e0a-4ed8-8400-8e8e02e29a7b	Heihachi	Kuboe	M	f	\N	\N	\N	\N	\N	{"original_name": "久保江 平八"}
e01927e9-11a5-46a9-a060-baba807daf43	Akira	Kitazaki	M	f	\N	\N	\N	\N	\N	{"original_name": "喜多崎 晃"}
ccf80df2-a664-4ca3-ad2c-b682ef456b3b	Kimio	Tobita	M	f	\N	\N	\N	\N	\N	{"original_name": "飛田 喜美雄"}
615f098e-644e-4429-98d6-8334a8e8ddec	Hiroshi	Mima	M	f	\N	\N	\N	\N	\N	{"original_name": "美間 博"}
a87ae5a4-cb4e-4605-aaaf-6ca63f38f892	Iwao	Otani	M	f	\N	\N	\N	\N	\N	{"original_name": "大谷 巖"}
c4a052b1-6559-493f-b0bf-ee05ebefc6fe	Kenzo	Ginya	M	f	\N	\N	\N	\N	\N	{"original_name": "銀屋 謙蔵"}
4e61a1bd-6487-45e6-a191-2c5700363891	Hiroshi	Ikeda	M	f	\N	\N	\N	\N	\N	{"original_name": "池田 博"}
55575c38-b55e-4bb0-b308-e36b03307420	Yoshi	Sugihara	M	f	\N	\N	\N	\N	\N	{"original_name": "杉原 よし"}
c5ae1c5e-6885-484b-a6bc-7d86ec7d4559	Takehiko	Sakuma	M	f	\N	\N	\N	\N	\N	{"original_name": "佐久間 丈彦"}
b86bdf63-3b93-45b4-9fac-e502ae05c8dc	Sozaburo	Shinomura	M	f	\N	\N	\N	\N	\N	\N
1efc7ab0-558e-40d5-9ff6-e7d469357984	Shoichi	Uehara	M	f	\N	\N	\N	\N	\N	{"original_name": "上原 正一"}
9a0aefbe-591f-4dae-9c4d-5ff785c4a061	Hiroshi	Yamada	M	f	\N	\N	\N	\N	\N	{"original_name": "山田 弘"}
b4496161-1678-4409-b9fd-da6ef674df01	Hiroshi	Imai	M	f	\N	\N	\N	\N	\N	{"original_name": "今井 ひろし"}
a63d1091-af4f-49a3-9520-a3eb2ff778d2	Shunsuke	Kikuchi	M	f	{"day": 1, "year": 1931, "month": 11}	\N	Hirosaki, Aomori, Japan	\N	\N	{"original_name": "菊池 俊輔"}
4139cd2f-a171-45dd-9606-0621de923045	Eibi	Motomochi	M	f	\N	\N	\N	\N	\N	{"original_name": "元持 栄美"}
89bb92ec-906d-4ae8-8296-1c917f0224b1	Takashi	Inomata	M	f	\N	\N	\N	\N	\N	{"original_name": "猪股 尭"}
7c84b99f-8441-4bca-b272-28871206e3c8	Noboru	Nishiyama	M	f	\N	\N	\N	\N	\N	{"original_name": "西山 登"}
ddcab35a-da50-4f15-8055-eef5b564db80	Kenjiro	Hirose	M	f	{"day": 5, "year": 1929, "month": 11}	{"day": 17, "year": 1999, "month": 3}	Hyogo, Japan	\N	\N	{"original_name": "廣瀬 健次郎"}
24f35657-5e36-479c-b16e-442878de6253	Kenji	Misumi	M	f	{"day": 2, "year": 1921, "month": 3}	{"day": 24, "year": 1975, "month": 9}	Kyoto, Japan	Kyoto, Japan	\N	{"original_name": "三隅 研次"}
d458d15a-475f-44c5-874a-6f3b29839182	Teiichi	Ito	M	f	\N	\N	\N	\N	\N	{"original_name": "伊藤 貞一"}
2e1c0225-a5f5-4b38-86e5-2cc9b3d04d63	Fumio	Anda	M	f	\N	\N	\N	\N	\N	{"original_name": "祖田 冨美夫"}
8aaea7b8-c2c0-4204-a62f-f6e0594f286e	Moriyoshi	Ishida	M	f	\N	\N	\N	\N	\N	{"original_name": "石田 守良"}
ef20d0c1-0371-4c88-91ec-a7b71b625ba8	Kyuzo	Kobayashi	M	f	{"day": 15, "year": 1935, "month": 11}	{"day": 1, "year": 2006, "month": 9}	\N	\N	\N	{"original_name": "小林 久三"}
2e2c8b9c-e622-4534-8196-2cd54cf9d3d5	Kazuo	Ota	M	f	\N	\N	\N	\N	\N	{"original_name": "太田 和夫"}
351512e7-428a-47ea-bb92-a234d14376af	Shogo	Sekiguchi	M	f	\N	\N	\N	\N	\N	{"original_name": "関口 章治"}
cabe2a54-774e-49c9-83f9-d86daf442136	Shozo	Tanaka	M	f	\N	\N	\N	\N	\N	{"original_name": "田中 省三"}
b819de2f-4340-4a22-bedc-9c6bfc49548c	Toshio	Taniguchi	M	f	\N	\N	\N	\N	\N	{"original_name": "谷口 登司夫"}
de047fb1-0bc8-4eaf-84f5-6b340342a5f3	Tetsuya	Yamanouchi	M	f	{"day": 20, "year": 1934, "month": 7}	{"day": 2, "year": 2010, "month": 4}	Hiroshima, Japan	\N	\N	{"original_name": "山内 鉄也"}
ac47d37c-4ba3-4920-8008-39bd496673f9	Shizuo	Hirase	M	f	\N	\N	\N	\N	\N	{"original_name": "平瀬 静雄"}
d06885ec-080f-49eb-9bd7-dd119fd1086c	Tsuneo	Koga	M	f	\N	\N	\N	\N	\N	{"original_name": "小角 恒雄"}
7a8706df-b467-4e81-9880-eefb297c4ad6	Kimiyoshi	Yasuda	M	f	{"day": 15, "year": 1911, "month": 2}	{"day": 26, "year": 1983, "month": 7}	Tokyo, Japan	\N	\N	{"original_name": "安田 公義"}
4b3a7838-059f-4398-8211-fd57a16453c7	Hajime	Sato	M	f	{"day": 3, "year": 1929, "month": 3}	{"day": 10, "year": 1995, "month": 5}	Saitama, Japan	\N	\N	{"original_name": "佐藤 肇"}
aa570b58-916a-4e25-895f-5d6393826fad	Masaru	Igami	M	f	{"day": 14, "year": 1931, "month": 7}	{"day": 16, "year": 1991, "month": 11}	Gunma	Japan	\N	{"original_name": "伊 上勝"}
1e947044-87dd-4398-859a-4f20184f86c8	Chita	Okoshi	U	f	\N	\N	\N	\N	\N	{"original_name": "大越 千虎"}
4282aa50-5c6f-411f-8293-36d2798949d7	Akimitsu	Terada	M	f	\N	\N	\N	\N	\N	{"original_name": "寺田 昭光"}
cb9f38a2-f124-49bb-b00d-7b5febaa8e15	Kunimoto	Amita	M	f	\N	\N	\N	\N	\N	{"original_name": "天田 欽元"}
d136912d-c3cc-4246-a9cc-0752da39dfab	Yoshiyuki	Kuroda	M	f	{"day": 4, "year": 1928, "month": 3}	{"day": 22, "year": 2015, "month": 1}	Matsuyama, Ehime, Japan	\N	\N	{"original_name": "黒田 義之"}
1d93ccc6-3f5f-4c5a-b933-76e890eb5adf	Masao	Osumi	M	f	\N	\N	\N	\N	\N	{"original_name": "大角 正夫"}
e3a5a656-330e-4f39-a068-228d6bcf1b87	Takeo	Nagamatsu	M	f	{"day": 1, "year": 1912, "month": 3}	{"day": 17, "year": 1961, "month": 11}	Oita, Japan	\N	\N	{"original_name": "永松 健夫"}
99da4137-2150-4449-bc63-91c854d9a477	Motoya	Washio	M	f	\N	\N	\N	\N	\N	{"original_name": "わし尾 元也"}
460ddeaf-4325-499f-aa2f-82e89782fe5d	Shigemori	Shigeta	M	f	\N	\N	\N	\N	\N	{"original_name": "重田 重盛"}
a49b90b1-3cb5-44ec-89d0-12da68234600	Koki	Matsuno	M	f	{"day": 9, "year": 1925, "month": 7}	{"unknown": 1}	Kiyone, Tsukubo, Okayama, Japan	\N	{"Hiroki Matsuno (松野 宏軌)"}	{"birth_name": "Hiroshi Matsuno (松野 博)", "original_name": "松野 宏軌"}
0acf9ae6-3158-4cba-8218-1c29e2db28fb	Takashi	Akamatsu	M	f	\N	\N	\N	\N	\N	\N
47e3892f-c0a6-45b7-bd5a-a964b7718a1d	Tetsuro	Yoshida	M	f	\N	\N	\N	\N	\N	{"original_name": "吉田 哲郎"}
d7d3674f-ff56-438a-af89-26cafa460c57	Kenji	Furuya	M	f	\N	\N	\N	\N	\N	{"original_name": "古谷 賢次"}
edf7cbdc-0c89-413c-bc52-ff7d7671aa7e	Susumu	Takaku	M	f	{"day": 11, "year": 1933, "month": 1}	{"day": 22, "year": 2009, "month": 7}	Fukushima, Japan	\N	\N	{"original_name": "高久 進"}
73378725-9e35-4f1f-b522-08ea234ce1e5	Shoji	Yada	M	f	\N	\N	\N	\N	\N	{"original_name": "矢田 精治"}
0e124ef1-d5e9-4473-8dad-ca7833fccb33	Hiroshi	Nakamura	M	f	\N	\N	\N	\N	\N	{"original_name": "中村 寛"}
22e872ab-b41f-48d0-a34d-f4e1987fade3	Kikuma	Shimoizaka	M	f	\N	\N	\N	\N	\N	{"original_name": "下飯坂 菊馬"}
bdf1596b-70f1-4d02-a4a7-47da0f31eee2	Tatsuo	Aomoto	M	f	\N	\N	\N	\N	\N	\N
23af9bb7-2ab0-4bff-a544-25a14711d8ec	Fujio	Morita	M	f	{"day": 14, "year": 1927, "month": 12}	{"day": 11, "year": 2014, "month": 6}	Uzumasa, Kadono, Kyoto, Japan	Kyoto, Japan	\N	{"original_name": "森田 富士郎"}
4b710372-cad8-4bf3-accb-59557dd8d8f3	Kanji	Suganuma	M	f	\N	\N	\N	\N	\N	{"original_name": "菅沼 完二"}
bee2d6b7-568f-4386-b380-2ebe35fdc297	Yoshikazu	Yamasawa	M	f	\N	\N	\N	\N	\N	{"original_name": "山沢 義一"}
139d9d4e-57f3-4a85-bf1b-f72ebcf0b2c0	Toshiaki	Tsushima	M	f	{"day": 22, "year": 1936, "month": 5}	{"day": 25, "year": 2013, "month": 11}	Okayama, Japan	\N	\N	{"original_name": "津島 利章"}
35dd54c6-d61a-471e-a6ad-fc2b4b992219	Masa	Tsubuki	M	f	\N	\N	\N	\N	\N	{"original_name": "津吹 正"}
094fbabe-38ec-4b55-a2a9-eaf5d712716b	Yunota	Yoshino	M	f	\N	\N	\N	\N	\N	{"original_name": "芳野 尹孝"}
395dcc9b-eee7-4108-9821-b298a36c3763	Masayuki	Kato	M	f	\N	\N	\N	\N	\N	{"original_name": "加藤 正幸"}
38b37c37-ad76-4398-ac1a-2bbac0274798	Akira	Naito	M	f	\N	\N	\N	\N	\N	{"original_name": "内藤 昭"}
e20f479b-3a6a-47d7-96e3-e7e31e723e46	Kazuo	Mori	M	f	{"day": 15, "year": 1911, "month": 1}	{"day": 29, "year": 1989, "month": 6}	Matsuyama, Ehime, Japan	\N	\N	{"original_name": "森 一生"}
d516b368-3b08-4d2d-845e-c3f2ae37033d	Shinichi	Eno	M	f	\N	\N	\N	\N	\N	{"original_name": "江野 慎一"}
96fdf693-30a4-4a4f-9df7-b038e2aeafeb	Tadao	Kanda	M	f	\N	\N	\N	\N	\N	{"original_name": "神田 忠男"}
48184ea8-dffd-4f03-8f73-57f5ff3d94d4	Toshifumi	Takahashi	M	f	\N	\N	\N	\N	\N	{"original_name": "高橋 利文"}
ff95dbdf-9c88-49ba-b744-67991d1f73cf	Kyohei	Morita	M	f	\N	\N	\N	\N	\N	{"original_name": "森田 郷平"}
9497e236-3905-40b9-b5ee-453b96fc5d89	Takeo	Hasegawa	M	f	\N	\N	\N	\N	\N	\N
9ea2c1cd-5f09-43a2-b33a-de182b57cae0	Tsuchitaro	Hayashi	M	f	{"day": 24, "year": 1922, "month": 3}	{"day": 9, "year": 2015, "month": 7}	Kyoto, Japan	Shimogyo, Kyoto, Japan	\N	{"original_name": "林 土太郎"}
f3aab2c2-4a3e-41b2-bdc7-787488acc1bc	Yoshinobu	Nishioka	M	f	{"day": 8, "year": 1922, "month": 7}	\N	Nara, Japan	\N	\N	{"original_name": "西岡 善信"}
d4374410-4d45-4928-9216-559cf8217068	Yosuke	Uchida	M	f	\N	\N	\N	\N	\N	{"original_name": "内田 陽造"}
0d8bace7-0e59-4e11-946c-5f33f08f03f1	Kazui	Nihonmatsu	M	f	{"day": 9, "year": 1922, "month": 4}	\N	Kamakura, Kanagawa, Japan	\N	\N	{"original_name": "二本松 嘉瑞"}
4dd7e01c-2b16-4fd3-b182-acea716de1cd	Taku	Izumi	M	f	{"day": 20, "year": 1930, "month": 1}	{"day": 11, "year": 1992, "month": 5}	Shitaya, Tokyo, Japan	\N	\N	{"birth_name": "Takao Imaizumi (今泉 隆雄)", "original_name": "いずみ たく"}
5e025577-ff1e-4462-9c3d-0446693fe1cd	Hideo	Kobayashi	M	f	\N	\N	\N	\N	\N	{"original_name": "小林 英男"}
0ac5ec0b-66de-41d3-86b3-599bed0ed8c9	Wataru	Nakajima	M	f	\N	\N	\N	\N	\N	\N
41004f90-bd9d-43ab-a5d4-d1d3f0b6f829	Shigeru	Kato	M	f	\N	\N	\N	\N	\N	{"original_name": "加藤 茂"}
55568fbd-5fe6-4dad-806a-b7b0d89ffdc5	Keizo	Kawasaki	M	f	{"day": 1, "year": 1933, "month": 7}	{"day": 21, "year": 2015, "month": 7}	Kawasaki, Kanagawa, Japan	Kawasaki, Kanagawa, Japan	\N	{"birth_name": "Yasuji Suyama (陶山 惠司)", "original_name": "川崎 敬三"}
8b799dcc-7588-403b-80f8-c0d4467c2019	Toyomi	Karita	F	f	\N	\N	\N	\N	\N	{"original_name": "苅田 とよみ"}
2a416760-6248-4c35-a23e-b8f6becf0f88	Isao	Yamagata	M	f	{"day": 25, "year": 1915, "month": 7}	{"day": 28, "year": 1996, "month": 7}	London, United Kingdom	Tokyo, Japan	\N	{"birth_name": "Isao Hanawa (塙 勲)", "original_name": "山形 勲"}
1e37d5f2-45c2-490b-915d-ba87309ae4ca	Shozo	Nanbu	M	f	{"day": 26, "year": 1898, "month": 6}	{"unknown": 1}	Hayami, Oita, Japan	\N	\N	{"original_name": "南部 彰三"}
686f2dc2-a12d-4f46-af2f-b0d3c81069c9	Bontaro	Miake	M	f	{"day": 15, "year": 1906, "month": 10}	{"year": 1987}	Masuda, Mino, Shimane, Japan	\N	\N	{"birth_name": "Susumu Miake (見明 先先)", "original_name": "見明 凡太朗"}
524b444f-a3c5-4fd2-b5a1-919939b43c4c	Mieko	Nagai	F	f	\N	\N	\N	\N	\N	{"original_name": "永井 ミエ子"}
1ec4e3df-c02f-44fd-a7cc-6b842bf44bb4	Kiyoko	Hirai	F	f	\N	\N	\N	\N	\N	{"original_name": "平井 岐代子"}
449ff18f-f1bf-4f74-b7d0-d725027fa078	Akira	Kurosawa	M	f	{"day": 23, "year": 1910, "month": 3}	{"day": 6, "year": 1998, "month": 9}	Oimachi, Ebara, Tokyo, Japan	Seijo, Setagaya, Tokyo, Japan	\N	{"original_name": "黒澤 明"}
50fd1eb9-7289-4cf4-bdc6-065797936bd7	Ryunosuke	Akutagawa	M	f	{"day": 1, "year": 1892, "month": 3}	{"day": 24, "year": 1927, "month": 7}	Kyobashi, Tokyo, Japan	Tabata, Takinogawa, Toshima, Tokyo, Japan	\N	{"original_name": "芥川 龍之介"}
2209b83b-f80d-4f9b-be22-838581803d4b	Shinobu	Hashimoto	M	f	{"day": 18, "year": 1918, "month": 4}	\N	Tsurui, Kisaki, Hyogo, Japan	\N	\N	{"original_name": "橋本 忍"}
786ceebd-6927-4242-a1cd-5933186090c3	Kazuo	Miyakawa	M	f	{"day": 25, "year": 1908, "month": 2}	{"day": 7, "year": 1999, "month": 8}	Oike, Kawaramachi, Kyoto, Japan	\N	\N	{"original_name": "宮川 一夫"}
4c0538b4-3e0f-41ab-b29a-cf058f7f0708	Takashi	Matsuyama	M	f	{"day": 22, "year": 1908, "month": 9}	{"day": 14, "year": 1977, "month": 7}	Kobe, Hyogo, Japan	\N	\N	{"original_name": "松山 崇"}
cbf78cce-3676-40c9-b871-0dcddd5423df	Fumio	Hayasaka	M	f	{"day": 19, "year": 1914, "month": 8}	{"day": 15, "year": 1955, "month": 10}	Sendai, Miyagi, Japan	Setagaya, Kenichi, Tokyo, Japan	\N	{"original_name": "早坂 文雄"}
fafb356d-5415-434e-9809-afd08177a68d	Kenichi	Okamoto	M	f	\N	\N	\N	\N	\N	{"original_name": "岡本 健一"}
e1099923-73b2-4388-8718-0bbeb2b38fe3	Shigeo	Nishida	M	f	\N	\N	\N	\N	\N	{"original_name": "西田 重雄"}
c004779d-f965-4224-bb76-1f81f0a49f3b	Eiji	Yoshikawa	M	f	{"day": 11, "year": 1892, "month": 8}	{"day": 7, "year": 1962, "month": 9}	Negishi, Nakamura, Hisaigi, Kanagawa, Japan	Tokyo, Japan	\N	{"original_name": "吉川 英治"}
a0960493-3319-412c-afa8-1379f398b03e	Hideji	Hojo	M	f	{"day": 7, "year": 1902, "month": 11}	{"day": 19, "year": 1996, "month": 5}	Osaka, Japan	\N	\N	{"original_name": "北條 秀司"}
f0551015-29c5-4b37-8b5c-298ee971ea76	Tokuhei	Wakao	M	f	\N	\N	\N	\N	\N	{"original_name": "若尾 徳平"}
ffe848b7-80ec-4d5b-ba89-e1fc757c92d0	Jun	Yasumoto	M	f	\N	\N	\N	\N	\N	{"original_name": "安本 淳"}
d9450e7b-d3e4-4def-9922-8896ebfa3ae6	Hidefumi	Oi	M	f	\N	\N	\N	\N	\N	{"original_name": "大井 英史"}
dcf535d9-0eeb-4d33-9323-6c9a5222056e	Asakazu	Nakai	M	f	{"day": 29, "year": 1901, "month": 8}	{"day": 28, "year": 1988, "month": 2}	Hyogo, Japan	\N	\N	{"original_name": "中井 朝一"}
fe66f8e5-725a-4936-ac68-57c5c4d8083f	Sojiro	Motoki	M	f	{"day": 19, "year": 1914, "month": 6}	{"day": 21, "year": 1977, "month": 5}	Shimbashi, Shiba, Tokyo, Japan	Shinjuku, Tokyo, Japan	{"Tamezo Shibuya (渋谷 民三)","Takeo Takagi (高木 丈夫)","Junzo Fujimoto (藤本 潤三)","Junji Fujimoto (藤本 潤二)"}	{"original_name": "本木 荘二郎"}
f4d4339a-2409-4d7c-a54c-b3696b9cbd43	Kohei	Ezaki	M	f	{"day": 15, "year": 1904, "month": 6}	{"day": 27, "year": 1963, "month": 6}	Takato, Kamina, Nagano, Japan	Meguro, Tokyo, Japan	\N	{"original_name": "江崎 孝坪"}
0c5b7ba3-0ddb-4948-92e3-5f18d542e397	Yoshiro	Muraki	M	f	{"day": 15, "year": 1924, "month": 8}	{"day": 26, "year": 2009, "month": 10}	Tokyo, Japan	Tokyo, Japan	\N	{"original_name": "村木 与四郎"}
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_migrations (version, inserted_at) FROM stdin;
20161006021230	2016-10-07 00:23:34
20161007001507	2016-10-07 12:45:18
20161010010437	2016-10-10 01:13:54
20161012005558	2016-10-12 00:59:00
20161023183018	2016-10-23 19:17:54
20161024005440	2016-10-24 00:55:45
20161024011358	2016-10-24 01:15:23
20161024013341	2016-10-24 01:36:53
20161024014602	2016-10-24 01:51:30
20161024021557	2016-10-24 02:17:58
20161026231444	2016-10-26 23:16:13
20161031213020	2016-10-31 21:34:29
20161101011845	2016-11-01 01:20:45
20161101225738	2016-11-01 22:59:21
20161112001546	2016-11-12 00:20:04
20161119001523	2016-11-19 00:17:38
20161119171348	2016-11-19 17:17:04
20161210024757	2016-12-10 02:50:26
20161210031323	2016-12-10 03:14:27
20161216193140	2016-12-16 19:44:59
20161217212636	2016-12-17 21:31:04
20161220232057	2016-12-20 23:24:47
20161226165612	2016-12-26 17:00:03
20161226213706	2016-12-26 21:38:27
20170107235902	2017-01-08 02:12:08
20170507184156	2017-05-07 21:14:16.523506
\.


--
-- Data for Name: series; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY series (id, name) FROM stdin;
abf663c4-4467-4a76-a25f-735b00fbc120	Godzilla
7719d635-5ead-451c-bd0a-f901523814aa	Frankenstein
27c45133-7fc7-45cb-9b43-01125c346bba	Gamera
662d184c-742a-48e0-b472-e6f7fb7a182e	Daimajin
4540124b-dfce-46b4-848f-73d6b20d6e5b	Samurai
\.


--
-- Data for Name: series_films; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY series_films (series_id, film_id, "order") FROM stdin;
abf663c4-4467-4a76-a25f-735b00fbc120	653335e2-101e-4303-90a2-eb71dac3c6e3	1
abf663c4-4467-4a76-a25f-735b00fbc120	7f9c68a7-8cec-4f4e-be97-528fe66605c3	2
abf663c4-4467-4a76-a25f-735b00fbc120	d6a05fe9-ea91-4b75-a04a-77c8217a56cd	3
abf663c4-4467-4a76-a25f-735b00fbc120	75bb901c-e41c-494f-aae8-7a5282f3bf96	4
abf663c4-4467-4a76-a25f-735b00fbc120	2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	5
abf663c4-4467-4a76-a25f-735b00fbc120	0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	6
abf663c4-4467-4a76-a25f-735b00fbc120	f474852a-cc25-477d-a7b9-06aa688f7fb2	7
abf663c4-4467-4a76-a25f-735b00fbc120	40cb6fad-15b4-46f5-8066-273cb965c3c4	8
abf663c4-4467-4a76-a25f-735b00fbc120	7be35dd2-8758-4cb8-85af-17985772d431	9
7719d635-5ead-451c-bd0a-f901523814aa	183fbe01-1bd2-4ade-b83b-6248ec7d7fee	1
7719d635-5ead-451c-bd0a-f901523814aa	23c1c82e-aedb-4c9b-b040-c780eec577e8	2
27c45133-7fc7-45cb-9b43-01125c346bba	0704c7e5-5709-4401-adaa-8cbec670e47d	1
27c45133-7fc7-45cb-9b43-01125c346bba	16789ef4-c05d-4f15-b09f-3bed5291655c	2
27c45133-7fc7-45cb-9b43-01125c346bba	40ca591f-8493-4fad-9527-464e3501e1d2	3
27c45133-7fc7-45cb-9b43-01125c346bba	bbfd5e01-14bc-4890-aab1-92a02bec413d	4
662d184c-742a-48e0-b472-e6f7fb7a182e	9ec4301a-1522-4af9-b83b-92d50b4f0db9	1
662d184c-742a-48e0-b472-e6f7fb7a182e	ff2cfc4e-76d6-4985-811f-834d4b7f5485	2
662d184c-742a-48e0-b472-e6f7fb7a182e	ce555690-494d-4983-a2a7-c99fb2fc0387	3
4540124b-dfce-46b4-848f-73d6b20d6e5b	14fab775-bb0f-413e-9840-be528e07ba70	1
4540124b-dfce-46b4-848f-73d6b20d6e5b	6c45cc47-8f6d-4861-95ab-4c9a2b404218	2
4540124b-dfce-46b4-848f-73d6b20d6e5b	8196e3f6-20f4-44a6-ab7c-d58dbedc4475	3
\.


--
-- Data for Name: staff_person_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY staff_person_roles (film_id, person_id, role, "order") FROM stdin;
7f9c68a7-8cec-4f4e-be97-528fe66605c3	c4d992f8-9b89-4eda-ae22-192e469d5c9f	Director	-2
7f9c68a7-8cec-4f4e-be97-528fe66605c3	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
7f9c68a7-8cec-4f4e-be97-528fe66605c3	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
7f9c68a7-8cec-4f4e-be97-528fe66605c3	d1cffc90-6783-4054-ba9f-032d593fc60c	Original Story	2
7f9c68a7-8cec-4f4e-be97-528fe66605c3	84c442af-6bd6-4e53-93c6-f4b213175de4	Screenplay	3
7f9c68a7-8cec-4f4e-be97-528fe66605c3	914bfc59-ae69-495a-9a25-b1138de87bb0	Screenplay	4
7f9c68a7-8cec-4f4e-be97-528fe66605c3	3ab19c1d-1525-46c0-a377-fe26be4e0950	Cinematography	5
7f9c68a7-8cec-4f4e-be97-528fe66605c3	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	6
7f9c68a7-8cec-4f4e-be97-528fe66605c3	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	8
7f9c68a7-8cec-4f4e-be97-528fe66605c3	8bd05431-0f6f-47f7-b4c0-c928590e0f5d	Lighting	9
7f9c68a7-8cec-4f4e-be97-528fe66605c3	54122b4f-936f-47e5-a637-3ba3d24763b9	Music	10
7f9c68a7-8cec-4f4e-be97-528fe66605c3	c7826ac4-c962-4f2e-b62b-b0258eeadbee	Editor	16
79a16ff9-c72a-4dd0-ba4e-67f578e97682	c4d992f8-9b89-4eda-ae22-192e469d5c9f	Director	-2
79a16ff9-c72a-4dd0-ba4e-67f578e97682	2869c9ca-e710-4a53-a103-ff393b129884	Cinematography	-1
79a16ff9-c72a-4dd0-ba4e-67f578e97682	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Supervisor	-1
79a16ff9-c72a-4dd0-ba4e-67f578e97682	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Producer	1
79a16ff9-c72a-4dd0-ba4e-67f578e97682	51ef93db-0b25-44e2-889d-b92768a49470	Original Story	2
79a16ff9-c72a-4dd0-ba4e-67f578e97682	914bfc59-ae69-495a-9a25-b1138de87bb0	Screenplay	3
79a16ff9-c72a-4dd0-ba4e-67f578e97682	5d149a9f-cd4e-4b01-91e5-934200b5dcdb	Art Director	4
79a16ff9-c72a-4dd0-ba4e-67f578e97682	07f8acfe-8d57-4c46-811c-8f499e27a989	Sound Recording	5
79a16ff9-c72a-4dd0-ba4e-67f578e97682	986d08ab-500a-4b71-a4e6-5cb2bcf6abb4	Lighting	6
79a16ff9-c72a-4dd0-ba4e-67f578e97682	89b2d627-c97d-45d4-9a49-2432c39b7fb4	Music	7
79a16ff9-c72a-4dd0-ba4e-67f578e97682	7782090a-df05-4bf5-8791-f8efac8951f4	Editor	9
ef4f2354-b764-4f5e-af66-813369a2520c	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
ef4f2354-b764-4f5e-af66-813369a2520c	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
ef4f2354-b764-4f5e-af66-813369a2520c	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
ef4f2354-b764-4f5e-af66-813369a2520c	acb4f84a-b52b-455d-a49a-65bc1d73dbe6	Original Story	2
ef4f2354-b764-4f5e-af66-813369a2520c	d1cffc90-6783-4054-ba9f-032d593fc60c	Screenplay	3
ef4f2354-b764-4f5e-af66-813369a2520c	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	4
ef4f2354-b764-4f5e-af66-813369a2520c	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	5
ef4f2354-b764-4f5e-af66-813369a2520c	5d149a9f-cd4e-4b01-91e5-934200b5dcdb	Art Director	6
ef4f2354-b764-4f5e-af66-813369a2520c	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	7
ef4f2354-b764-4f5e-af66-813369a2520c	986d08ab-500a-4b71-a4e6-5cb2bcf6abb4	Lighting	8
ef4f2354-b764-4f5e-af66-813369a2520c	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	9
ef4f2354-b764-4f5e-af66-813369a2520c	d1e73155-2bf5-4378-929f-277d92e5e2ae	Editor	12
ef4f2354-b764-4f5e-af66-813369a2520c	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	16
132ec70b-0248-450e-9ae2-38c8245dc2e9	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
132ec70b-0248-450e-9ae2-38c8245dc2e9	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
132ec70b-0248-450e-9ae2-38c8245dc2e9	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
132ec70b-0248-450e-9ae2-38c8245dc2e9	a37c4464-16f1-4754-b563-e247908a185c	Original Story	2
132ec70b-0248-450e-9ae2-38c8245dc2e9	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	3
132ec70b-0248-450e-9ae2-38c8245dc2e9	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	4
132ec70b-0248-450e-9ae2-38c8245dc2e9	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	5
132ec70b-0248-450e-9ae2-38c8245dc2e9	24651b22-cbb0-4472-9d73-c96ed96829d6	Sound Recording	6
132ec70b-0248-450e-9ae2-38c8245dc2e9	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	7
132ec70b-0248-450e-9ae2-38c8245dc2e9	b4a497d1-74e0-4304-bc20-7a32275c73ab	Lighting	8
132ec70b-0248-450e-9ae2-38c8245dc2e9	54122b4f-936f-47e5-a637-3ba3d24763b9	Music	9
132ec70b-0248-450e-9ae2-38c8245dc2e9	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	11
132ec70b-0248-450e-9ae2-38c8245dc2e9	c7826ac4-c962-4f2e-b62b-b0258eeadbee	Editor	16
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	730e679a-bb91-449b-86fb-3384fc4b9720	Original Story	2
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	3
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	4
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	8d818c87-fa3d-440c-9825-2def708d19cc	Art Director	5
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	3b40b2fd-e981-4429-9a99-85cc2d357f50	Sound Recording	6
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	7
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	08872122-2396-4e80-9a74-ef85447c4057	Lighting	8
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	9
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	d1e73155-2bf5-4378-929f-277d92e5e2ae	Editor	12
dbf96f34-252e-4cbb-bc3d-e7f74e8abea9	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	15
0a158e9d-6e48-4b6e-9674-862d952fb3ab	7991849b-aa0b-4efd-9759-dcc4ff87ceb1	Director	-2
0a158e9d-6e48-4b6e-9674-862d952fb3ab	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
0a158e9d-6e48-4b6e-9674-862d952fb3ab	36234a9f-5c59-4d3a-b25e-4428d8fe1472	Producer	1
0a158e9d-6e48-4b6e-9674-862d952fb3ab	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	2
0a158e9d-6e48-4b6e-9674-862d952fb3ab	6c891253-4c26-44fb-a952-fb1866d1819f	Screenplay	3
0a158e9d-6e48-4b6e-9674-862d952fb3ab	9da86934-7584-466a-84be-853819168103	Screenplay	4
0a158e9d-6e48-4b6e-9674-862d952fb3ab	a37d0291-2e69-40af-86f0-133859aaf1ff	Art Director	5
0a158e9d-6e48-4b6e-9674-862d952fb3ab	3df58f3a-039b-45ab-bf42-d842796cb7fe	Cinematography	6
0a158e9d-6e48-4b6e-9674-862d952fb3ab	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	7
0a158e9d-6e48-4b6e-9674-862d952fb3ab	a78fc680-c144-4f9a-8e27-fc69b70a463f	Sound Recording	9
0a158e9d-6e48-4b6e-9674-862d952fb3ab	6ad606bd-e3cb-45c2-b8a6-bb068854ffd7	Sound Recording	10
0a158e9d-6e48-4b6e-9674-862d952fb3ab	a7476494-4b15-4fd8-93b4-4548ed8f0086	Lighting	11
0a158e9d-6e48-4b6e-9674-862d952fb3ab	c7826ac4-c962-4f2e-b62b-b0258eeadbee	Editor	13
0a158e9d-6e48-4b6e-9674-862d952fb3ab	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	17
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	acb4f84a-b52b-455d-a49a-65bc1d73dbe6	Original Story	2
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	3
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	4
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	5d149a9f-cd4e-4b01-91e5-934200b5dcdb	Art Director	5
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	36e34390-71ca-4e42-a28e-e6944cc7d582	Lighting	6
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	24651b22-cbb0-4472-9d73-c96ed96829d6	Sound Recording	7
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	8
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	9
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	c7826ac4-c962-4f2e-b62b-b0258eeadbee	Editor	11
b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	15
249785ea-a53b-43e3-94d6-c5d2f2d833c4	890b42f6-f12a-4afb-8b82-e1f37a6b4dc9	Director	-2
249785ea-a53b-43e3-94d6-c5d2f2d833c4	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
249785ea-a53b-43e3-94d6-c5d2f2d833c4	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
249785ea-a53b-43e3-94d6-c5d2f2d833c4	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	2
249785ea-a53b-43e3-94d6-c5d2f2d833c4	3df58f3a-039b-45ab-bf42-d842796cb7fe	Cinematography	3
249785ea-a53b-43e3-94d6-c5d2f2d833c4	e14a8f59-a0e9-4286-be13-24559916e2c4	Art Director	4
249785ea-a53b-43e3-94d6-c5d2f2d833c4	a78fc680-c144-4f9a-8e27-fc69b70a463f	Sound Recording	5
249785ea-a53b-43e3-94d6-c5d2f2d833c4	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	6
249785ea-a53b-43e3-94d6-c5d2f2d833c4	b4a497d1-74e0-4304-bc20-7a32275c73ab	Lighting	7
249785ea-a53b-43e3-94d6-c5d2f2d833c4	7a593862-ec98-49bb-bd73-b35094f16971	Music	8
249785ea-a53b-43e3-94d6-c5d2f2d833c4	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	10
249785ea-a53b-43e3-94d6-c5d2f2d833c4	c7826ac4-c962-4f2e-b62b-b0258eeadbee	Editor	15
e8ccb201-e076-48cb-9307-f8b99101f133	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
e8ccb201-e076-48cb-9307-f8b99101f133	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
e8ccb201-e076-48cb-9307-f8b99101f133	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
e8ccb201-e076-48cb-9307-f8b99101f133	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	2
e8ccb201-e076-48cb-9307-f8b99101f133	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	3
e8ccb201-e076-48cb-9307-f8b99101f133	8d818c87-fa3d-440c-9825-2def708d19cc	Art Director	4
e8ccb201-e076-48cb-9307-f8b99101f133	e12e2330-3a9a-489b-b6ed-7d9746a406d6	Sound Recording	5
e8ccb201-e076-48cb-9307-f8b99101f133	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	6
e8ccb201-e076-48cb-9307-f8b99101f133	b8928aa8-991f-46b3-aca4-c72ba3656249	Lighting	7
e8ccb201-e076-48cb-9307-f8b99101f133	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	9
e8ccb201-e076-48cb-9307-f8b99101f133	43f92b30-e8dc-496c-836f-a39ec34ce058	Music	12
e8ccb201-e076-48cb-9307-f8b99101f133	c7826ac4-c962-4f2e-b62b-b0258eeadbee	Editor	18
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	1009b31a-0266-4068-a9b8-f4b58d423490	Original Story	2
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	c75a73c4-ed27-468e-b065-ff5a764f80e3	Original Story	3
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	d7c89e93-28a0-4ac3-833f-fea8014e11f4	Original Story	4
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	5
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	6
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	7
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	5d149a9f-cd4e-4b01-91e5-934200b5dcdb	Art Director	8
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	07f8acfe-8d57-4c46-811c-8f499e27a989	Sound Recording	9
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	10
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	b8928aa8-991f-46b3-aca4-c72ba3656249	Lighting	11
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	12f88b8e-e9ba-4771-9c4d-786dc69c24af	Music	12
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	c7826ac4-c962-4f2e-b62b-b0258eeadbee	Editor	17
a62c9a6b-aa36-4d5d-b869-2fc79efa28ab	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	20
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	acb4f84a-b52b-455d-a49a-65bc1d73dbe6	Original Story	2
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	3
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	4
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	5
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	5d149a9f-cd4e-4b01-91e5-934200b5dcdb	Art Director	6
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	1c30afb0-3f4d-4017-84fd-cb68e9a2e6f0	Sound Recording	7
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	b8928aa8-991f-46b3-aca4-c72ba3656249	Lighting	8
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	293342a6-c449-4ec7-9103-b3091a184cd2	Music	9
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	28c62b3a-217d-4a2f-aab1-3fd7817bd189	Editor	12
80731aaf-e8e4-4c5b-bd80-e033bd3a7daa	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	15
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	2
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	3
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	4
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	5d149a9f-cd4e-4b01-91e5-934200b5dcdb	Art Director	5
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	e12e2330-3a9a-489b-b6ed-7d9746a406d6	Sound Recording	6
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	b8928aa8-991f-46b3-aca4-c72ba3656249	Lighting	7
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	8
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	28c62b3a-217d-4a2f-aab1-3fd7817bd189	Editor	11
d6a05fe9-ea91-4b75-a04a-77c8217a56cd	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	14
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	00493c23-4851-4450-8d22-99eebd381727	Original Story	2
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	1877d46d-9ace-4741-836c-0b03933c496d	Original Story	3
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	c9c178e8-1d9e-410e-af95-01a1cbfda822	Original Story	4
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	5
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	6
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	48a7856e-e00d-410a-8dee-c9069575da5c	Art Director	7
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	8fbf0eb6-d46a-4f69-94ca-c3bfaf6b5e07	Sound Recording	8
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	a7476494-4b15-4fd8-93b4-4548ed8f0086	Lighting	9
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	b7285384-4240-4eaf-b9c0-ca8fcdc74233	Music	10
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	28c62b3a-217d-4a2f-aab1-3fd7817bd189	Editor	13
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	17
7df339b8-5cc8-4cfc-87a7-d8012c2a9916	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	24
b30c5657-a980-489b-bd91-d58e63609102	ca4cc2b9-e3bd-4219-a758-b024d9b511db	Director	-2
b30c5657-a980-489b-bd91-d58e63609102	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
b30c5657-a980-489b-bd91-d58e63609102	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
b30c5657-a980-489b-bd91-d58e63609102	d031da60-ed80-44ee-b7e3-582c8d241aa6	Producer	2
b30c5657-a980-489b-bd91-d58e63609102	6c891253-4c26-44fb-a952-fb1866d1819f	Story Coordinator	3
b30c5657-a980-489b-bd91-d58e63609102	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	4
b30c5657-a980-489b-bd91-d58e63609102	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	5
b30c5657-a980-489b-bd91-d58e63609102	9d1ccb86-2857-4a3a-b0e3-f30030053941	Cinematography	6
b30c5657-a980-489b-bd91-d58e63609102	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	7
b30c5657-a980-489b-bd91-d58e63609102	b16d5b1e-8e3e-4814-9155-0a2eb9e06e3b	Sound Recording	8
b30c5657-a980-489b-bd91-d58e63609102	6afdc4fe-fec9-4640-9299-40d56e5fb25a	Lighting	9
b30c5657-a980-489b-bd91-d58e63609102	54122b4f-936f-47e5-a637-3ba3d24763b9	Music	10
b30c5657-a980-489b-bd91-d58e63609102	cd54d1db-167c-4361-98c4-6ebf75294ad0	Editor	13
b30c5657-a980-489b-bd91-d58e63609102	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	18
b30c5657-a980-489b-bd91-d58e63609102	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	25
5df297a2-5f6d-430d-b7fc-952e97ac9d79	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
5df297a2-5f6d-430d-b7fc-952e97ac9d79	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
5df297a2-5f6d-430d-b7fc-952e97ac9d79	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
5df297a2-5f6d-430d-b7fc-952e97ac9d79	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	2
5df297a2-5f6d-430d-b7fc-952e97ac9d79	f298c956-ac3a-4d29-b92b-462c16b833e1	Original Story	3
5df297a2-5f6d-430d-b7fc-952e97ac9d79	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	4
5df297a2-5f6d-430d-b7fc-952e97ac9d79	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	5
5df297a2-5f6d-430d-b7fc-952e97ac9d79	6b8891db-a29b-4d5d-8635-c55f5c49e2ca	Sound Recording	6
5df297a2-5f6d-430d-b7fc-952e97ac9d79	a7476494-4b15-4fd8-93b4-4548ed8f0086	Lighting	7
5df297a2-5f6d-430d-b7fc-952e97ac9d79	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	8
5df297a2-5f6d-430d-b7fc-952e97ac9d79	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	11
5df297a2-5f6d-430d-b7fc-952e97ac9d79	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	15
5df297a2-5f6d-430d-b7fc-952e97ac9d79	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	22
75bb901c-e41c-494f-aae8-7a5282f3bf96	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
ef01babe-d621-40ca-8d85-363b051921a6	094fbabe-38ec-4b55-a2a9-eaf5d712716b	Art	6
75bb901c-e41c-494f-aae8-7a5282f3bf96	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
75bb901c-e41c-494f-aae8-7a5282f3bf96	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
75bb901c-e41c-494f-aae8-7a5282f3bf96	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	2
75bb901c-e41c-494f-aae8-7a5282f3bf96	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	3
75bb901c-e41c-494f-aae8-7a5282f3bf96	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	4
75bb901c-e41c-494f-aae8-7a5282f3bf96	8fbf0eb6-d46a-4f69-94ca-c3bfaf6b5e07	Sound Recording	5
75bb901c-e41c-494f-aae8-7a5282f3bf96	a7476494-4b15-4fd8-93b4-4548ed8f0086	Lighting	6
75bb901c-e41c-494f-aae8-7a5282f3bf96	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	7
75bb901c-e41c-494f-aae8-7a5282f3bf96	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	10
75bb901c-e41c-494f-aae8-7a5282f3bf96	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	14
75bb901c-e41c-494f-aae8-7a5282f3bf96	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	21
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	112a9c74-dd0f-4d1b-b020-18ad1062e48f	Producer	2
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	acb4f84a-b52b-455d-a49a-65bc1d73dbe6	Original Story	3
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	4
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	5
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	6
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	8fbf0eb6-d46a-4f69-94ca-c3bfaf6b5e07	Sound Recording	7
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	a7476494-4b15-4fd8-93b4-4548ed8f0086	Lighting	8
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	9
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	12
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	16
700c2ce1-095e-48ac-96c0-1d31f0c4e52b	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	23
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	2
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	3
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	4
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	8fbf0eb6-d46a-4f69-94ca-c3bfaf6b5e07	Sound Recording	5
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	a7476494-4b15-4fd8-93b4-4548ed8f0086	Lighting	6
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	7
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	12
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	16
2f761ce5-34ae-4e7e-8ce0-90fec7f94f68	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	23
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	2
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	3
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	4
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	3b40b2fd-e981-4429-9a99-85cc2d357f50	Sound Recording	5
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	a7476494-4b15-4fd8-93b4-4548ed8f0086	Lighting	6
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	7
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	10
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	14
183fbe01-1bd2-4ade-b83b-6248ec7d7fee	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	21
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	2
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	3
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	4
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	3b40b2fd-e981-4429-9a99-85cc2d357f50	Sound Recording	5
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	a7476494-4b15-4fd8-93b4-4548ed8f0086	Lighting	6
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	7
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	10
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	16
0a2401ee-c5da-4e00-a2bc-d6ae7026aa13	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	23
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	ca4cc2b9-e3bd-4219-a758-b024d9b511db	Director	-1
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	5a7a9af3-554a-451b-8835-78595116a9ff	Assistant Producer	2
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	3
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	e77691f8-05d7-4ae8-a582-c51c41de9f0c	Original Story	4
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	3df58f3a-039b-45ab-bf42-d842796cb7fe	Cinematography	5
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	f6e9be35-e3c6-41c6-b7d1-076cede500a2	Art Director	6
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	a78fc680-c144-4f9a-8e27-fc69b70a463f	Sound Recording	7
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	88bd531f-1ba5-40c9-9e81-4bf05ee61fce	Lighting	8
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	9
3b0b0351-0b4b-4ab1-a84e-6fc554c86a31	cd54d1db-167c-4361-98c4-6ebf75294ad0	Editor	12
f474852a-cc25-477d-a7b9-06aa688f7fb2	890b42f6-f12a-4afb-8b82-e1f37a6b4dc9	Director	-2
f474852a-cc25-477d-a7b9-06aa688f7fb2	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
f474852a-cc25-477d-a7b9-06aa688f7fb2	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
f474852a-cc25-477d-a7b9-06aa688f7fb2	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	2
f474852a-cc25-477d-a7b9-06aa688f7fb2	3df58f3a-039b-45ab-bf42-d842796cb7fe	Cinematography	3
f474852a-cc25-477d-a7b9-06aa688f7fb2	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	4
f474852a-cc25-477d-a7b9-06aa688f7fb2	78f3b649-dfe7-49bc-aeb4-d4e02a28e67c	Sound Recording	5
f474852a-cc25-477d-a7b9-06aa688f7fb2	6afdc4fe-fec9-4640-9299-40d56e5fb25a	Lighting	6
f474852a-cc25-477d-a7b9-06aa688f7fb2	54122b4f-936f-47e5-a637-3ba3d24763b9	Music	7
f474852a-cc25-477d-a7b9-06aa688f7fb2	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	10
f474852a-cc25-477d-a7b9-06aa688f7fb2	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Assistant Director	14
f474852a-cc25-477d-a7b9-06aa688f7fb2	a3950f6b-b64a-4bd3-ba7e-a86641c7763e	Special Effects Art Director	17
f474852a-cc25-477d-a7b9-06aa688f7fb2	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	21
23c1c82e-aedb-4c9b-b040-c780eec577e8	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
23c1c82e-aedb-4c9b-b040-c780eec577e8	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
23c1c82e-aedb-4c9b-b040-c780eec577e8	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
23c1c82e-aedb-4c9b-b040-c780eec577e8	d031da60-ed80-44ee-b7e3-582c8d241aa6	Producer	2
23c1c82e-aedb-4c9b-b040-c780eec577e8	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	3
23c1c82e-aedb-4c9b-b040-c780eec577e8	5358c92d-79db-46c1-83d5-ab6b1444506a	Screenplay	4
23c1c82e-aedb-4c9b-b040-c780eec577e8	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	5
23c1c82e-aedb-4c9b-b040-c780eec577e8	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	6
23c1c82e-aedb-4c9b-b040-c780eec577e8	d99098d2-e43a-46a0-99aa-9458a2892bb1	Sound Recording	7
23c1c82e-aedb-4c9b-b040-c780eec577e8	b8928aa8-991f-46b3-aca4-c72ba3656249	Lighting	8
23c1c82e-aedb-4c9b-b040-c780eec577e8	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	9
23c1c82e-aedb-4c9b-b040-c780eec577e8	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	12
23c1c82e-aedb-4c9b-b040-c780eec577e8	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	16
23c1c82e-aedb-4c9b-b040-c780eec577e8	a3950f6b-b64a-4bd3-ba7e-a86641c7763e	Special Effects Art Director	19
23c1c82e-aedb-4c9b-b040-c780eec577e8	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	23
ba6031ef-c7b0-451c-8465-cb2a3c494896	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-2
ba6031ef-c7b0-451c-8465-cb2a3c494896	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
ba6031ef-c7b0-451c-8465-cb2a3c494896	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
ba6031ef-c7b0-451c-8465-cb2a3c494896	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	2
ba6031ef-c7b0-451c-8465-cb2a3c494896	6976faf1-cfe4-489a-9dd5-c76f1ecc969b	Technical Advisor	3
ba6031ef-c7b0-451c-8465-cb2a3c494896	90aad09a-2931-43e7-9f4d-1726e5f68685	Cinematography	4
ba6031ef-c7b0-451c-8465-cb2a3c494896	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	5
ba6031ef-c7b0-451c-8465-cb2a3c494896	78f3b649-dfe7-49bc-aeb4-d4e02a28e67c	Sound Recording	6
ba6031ef-c7b0-451c-8465-cb2a3c494896	b8928aa8-991f-46b3-aca4-c72ba3656249	Lighting	7
ba6031ef-c7b0-451c-8465-cb2a3c494896	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	8
ba6031ef-c7b0-451c-8465-cb2a3c494896	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	11
ba6031ef-c7b0-451c-8465-cb2a3c494896	a3950f6b-b64a-4bd3-ba7e-a86641c7763e	Special Effects Art Director	18
ba6031ef-c7b0-451c-8465-cb2a3c494896	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	22
40cb6fad-15b4-46f5-8066-273cb965c3c4	890b42f6-f12a-4afb-8b82-e1f37a6b4dc9	Director	-3
40cb6fad-15b4-46f5-8066-273cb965c3c4	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Director	-2
40cb6fad-15b4-46f5-8066-273cb965c3c4	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Supervisor	-1
40cb6fad-15b4-46f5-8066-273cb965c3c4	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
40cb6fad-15b4-46f5-8066-273cb965c3c4	7a824d10-6fce-4915-9b7b-47a8a3bf5915	Screenplay	2
40cb6fad-15b4-46f5-8066-273cb965c3c4	475b78c0-45ad-46dc-8c99-b41a09ee2ec5	Screenplay	3
40cb6fad-15b4-46f5-8066-273cb965c3c4	3df58f3a-039b-45ab-bf42-d842796cb7fe	Cinematography	4
40cb6fad-15b4-46f5-8066-273cb965c3c4	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	5
40cb6fad-15b4-46f5-8066-273cb965c3c4	b16d5b1e-8e3e-4814-9155-0a2eb9e06e3b	Sound Recording	6
40cb6fad-15b4-46f5-8066-273cb965c3c4	1c30afb0-3f4d-4017-84fd-cb68e9a2e6f0	Sound Recording	7
40cb6fad-15b4-46f5-8066-273cb965c3c4	b9d6e433-dbac-4a1d-bb5b-1bdc316dfcb4	Lighting	8
40cb6fad-15b4-46f5-8066-273cb965c3c4	a7476494-4b15-4fd8-93b4-4548ed8f0086	Lighting	9
40cb6fad-15b4-46f5-8066-273cb965c3c4	54122b4f-936f-47e5-a637-3ba3d24763b9	Music	10
40cb6fad-15b4-46f5-8066-273cb965c3c4	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	13
40cb6fad-15b4-46f5-8066-273cb965c3c4	a3950f6b-b64a-4bd3-ba7e-a86641c7763e	Special Effects Art Director	20
40cb6fad-15b4-46f5-8066-273cb965c3c4	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	24
7be35dd2-8758-4cb8-85af-17985772d431	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-3
7be35dd2-8758-4cb8-85af-17985772d431	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Director	-2
7be35dd2-8758-4cb8-85af-17985772d431	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Supervisor	-1
7be35dd2-8758-4cb8-85af-17985772d431	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
7be35dd2-8758-4cb8-85af-17985772d431	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	2
7be35dd2-8758-4cb8-85af-17985772d431	5358c92d-79db-46c1-83d5-ab6b1444506a	Screenplay	3
7be35dd2-8758-4cb8-85af-17985772d431	f8797cb2-6240-46d2-9772-5a58aeb0bc2e	Cinematography	4
7be35dd2-8758-4cb8-85af-17985772d431	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	5
7be35dd2-8758-4cb8-85af-17985772d431	78f3b649-dfe7-49bc-aeb4-d4e02a28e67c	Sound Recording	6
7be35dd2-8758-4cb8-85af-17985772d431	e0d84176-6d73-4185-919e-ddb1fb22f400	Lighting	7
7be35dd2-8758-4cb8-85af-17985772d431	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	8
7be35dd2-8758-4cb8-85af-17985772d431	aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184	Editor	11
7be35dd2-8758-4cb8-85af-17985772d431	a3950f6b-b64a-4bd3-ba7e-a86641c7763e	Special Effects Art Director	16
7be35dd2-8758-4cb8-85af-17985772d431	f1c68ad7-5e4e-4bf8-a174-966878e7bfd5	Special Effects Assistant Director	21
9b724e83-39e6-4e57-b112-81e74d578ae0	20412681-252e-48bb-a69f-4617d10bbdb1	Director	-2
9b724e83-39e6-4e57-b112-81e74d578ae0	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	-1
9b724e83-39e6-4e57-b112-81e74d578ae0	36234a9f-5c59-4d3a-b25e-4428d8fe1472	Producer	1
9b724e83-39e6-4e57-b112-81e74d578ae0	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	2
9b724e83-39e6-4e57-b112-81e74d578ae0	6c891253-4c26-44fb-a952-fb1866d1819f	Screenplay	3
9b724e83-39e6-4e57-b112-81e74d578ae0	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	4
9b724e83-39e6-4e57-b112-81e74d578ae0	07259617-c6ef-42ad-afac-b37d29f83e4e	Cinematography	5
9b724e83-39e6-4e57-b112-81e74d578ae0	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	6
9b724e83-39e6-4e57-b112-81e74d578ae0	5d149a9f-cd4e-4b01-91e5-934200b5dcdb	Art Director	7
9b724e83-39e6-4e57-b112-81e74d578ae0	8fbf0eb6-d46a-4f69-94ca-c3bfaf6b5e07	Sound Recording	8
9b724e83-39e6-4e57-b112-81e74d578ae0	88bd531f-1ba5-40c9-9e81-4bf05ee61fce	Lighting	9
9b724e83-39e6-4e57-b112-81e74d578ae0	60c38e10-e1ed-46f5-b167-2938649e4503	Music	10
9b724e83-39e6-4e57-b112-81e74d578ae0	d1e73155-2bf5-4378-929f-277d92e5e2ae	Editor	13
9b724e83-39e6-4e57-b112-81e74d578ae0	c83bbdef-93a5-45dd-a789-5d44400ab825	Special Effects Cinematography	16
653335e2-101e-4303-90a2-eb71dac3c6e3	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-1
653335e2-101e-4303-90a2-eb71dac3c6e3	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
653335e2-101e-4303-90a2-eb71dac3c6e3	d1cffc90-6783-4054-ba9f-032d593fc60c	Original Story	2
653335e2-101e-4303-90a2-eb71dac3c6e3	84c442af-6bd6-4e53-93c6-f4b213175de4	Screenplay	3
653335e2-101e-4303-90a2-eb71dac3c6e3	5358c92d-79db-46c1-83d5-ab6b1444506a	Screenplay	4
653335e2-101e-4303-90a2-eb71dac3c6e3	802c7416-8696-4075-a778-83314da7310d	Cinematography	5
653335e2-101e-4303-90a2-eb71dac3c6e3	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	6
653335e2-101e-4303-90a2-eb71dac3c6e3	6ad606bd-e3cb-45c2-b8a6-bb068854ffd7	Sound Recording	8
653335e2-101e-4303-90a2-eb71dac3c6e3	33c417fc-2635-4667-aaa7-feab79073d9d	Lighting	9
653335e2-101e-4303-90a2-eb71dac3c6e3	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	10
653335e2-101e-4303-90a2-eb71dac3c6e3	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects	11
653335e2-101e-4303-90a2-eb71dac3c6e3	c7826ac4-c962-4f2e-b62b-b0258eeadbee	Editor	16
56dab76c-fc4d-4547-b2fe-3a743154f1d5	5358c92d-79db-46c1-83d5-ab6b1444506a	Director	-1
56dab76c-fc4d-4547-b2fe-3a743154f1d5	c6877155-e133-42c0-874b-1aba9fd78b16	Producer	1
56dab76c-fc4d-4547-b2fe-3a743154f1d5	730e679a-bb91-449b-86fb-3384fc4b9720	Original Story	2
56dab76c-fc4d-4547-b2fe-3a743154f1d5	84c442af-6bd6-4e53-93c6-f4b213175de4	Screenplay	3
56dab76c-fc4d-4547-b2fe-3a743154f1d5	61b4cc3d-d5bd-4e56-9b40-ae56497e3e88	Screenplay	4
56dab76c-fc4d-4547-b2fe-3a743154f1d5	5f8cfa7b-c504-4902-bd08-e030af359323	Cinematography	5
56dab76c-fc4d-4547-b2fe-3a743154f1d5	c70d0b2e-8511-4bfb-8527-808b3fef2a09	Art Director	6
56dab76c-fc4d-4547-b2fe-3a743154f1d5	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	7
56dab76c-fc4d-4547-b2fe-3a743154f1d5	e4fc3ee2-b54f-4ec0-8a84-64352507c5de	Lighting	8
56dab76c-fc4d-4547-b2fe-3a743154f1d5	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	9
56dab76c-fc4d-4547-b2fe-3a743154f1d5	2869c9ca-e710-4a53-a103-ff393b129884	Special Effects Director	10
56dab76c-fc4d-4547-b2fe-3a743154f1d5	890b42f6-f12a-4afb-8b82-e1f37a6b4dc9	Assistant Director	15
56dab76c-fc4d-4547-b2fe-3a743154f1d5	d1e73155-2bf5-4378-929f-277d92e5e2ae	Editor	16
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	a1d942b8-21be-40de-be75-6a2d63a7d5f8	Director	-1
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	a5e97a63-5c15-41ba-85c9-71f2c7af4f01	Producer	1
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	3d231f5f-cbda-4086-ac77-7403eac26317	Original Story	3
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	b54ca5c3-b7bf-4ad3-a3eb-8b30339ffa54	Screenplay	4
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	fbe37cd8-26cf-4808-a578-a89f947afb36	Cinematography	5
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	72416ff4-fecf-4f02-9dd8-9936854ecef8	Sound Recording	6
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	4cafc82d-fc63-42a5-bfc3-8894faa35e9f	Lighting	7
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	5f8fa4d8-e602-4040-a06e-5644578718f6	Art Director	8
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	fb0028bf-9f32-4434-896e-5bff5f4777fb	Music	33
7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8	fc69e110-1c48-4727-bde1-66e526756bcc	Editor	35
0704c7e5-5709-4401-adaa-8cbec670e47d	7887e636-a848-430c-8436-293b47151fd0	Director	-1
0704c7e5-5709-4401-adaa-8cbec670e47d	f1a27fcf-fc61-4758-b3d7-dab10b1303e9	Screenplay	2
0704c7e5-5709-4401-adaa-8cbec670e47d	114fce55-397a-4d9a-8e51-e6cf35909748	Cinematography	3
0704c7e5-5709-4401-adaa-8cbec670e47d	740d232d-bd82-4b4a-b555-5e0d95ddf757	Sound Recording	4
0704c7e5-5709-4401-adaa-8cbec670e47d	df40aa02-23ca-407e-96ba-0aceacdbbdea	Lighting	5
0704c7e5-5709-4401-adaa-8cbec670e47d	b322f19f-bf67-4e2c-8a50-476de85f537b	Art Director	6
0704c7e5-5709-4401-adaa-8cbec670e47d	1715410d-9cf0-4ecd-9857-4fb5f1bd4b97	Music	7
0704c7e5-5709-4401-adaa-8cbec670e47d	09aaa976-2352-491d-b7d1-27bf5b0fd8c5	Editor	8
9ec4301a-1522-4af9-b83b-92d50b4f0db9	7a8706df-b467-4e81-9880-eefb297c4ad6	Director	-2
9ec4301a-1522-4af9-b83b-92d50b4f0db9	d136912d-c3cc-4246-a9cc-0752da39dfab	Special Effects Director	-1
9ec4301a-1522-4af9-b83b-92d50b4f0db9	a5e97a63-5c15-41ba-85c9-71f2c7af4f01	Producer	1
9ec4301a-1522-4af9-b83b-92d50b4f0db9	47e3892f-c0a6-45b7-bd5a-a964b7718a1d	Screenplay	3
9ec4301a-1522-4af9-b83b-92d50b4f0db9	23af9bb7-2ab0-4bff-a544-25a14711d8ec	Cinematography	4
9ec4301a-1522-4af9-b83b-92d50b4f0db9	9ea2c1cd-5f09-43a2-b33a-de182b57cae0	Sound Recording	5
9ec4301a-1522-4af9-b83b-92d50b4f0db9	615f098e-644e-4429-98d6-8334a8e8ddec	Lighting	6
9ec4301a-1522-4af9-b83b-92d50b4f0db9	38b37c37-ad76-4398-ac1a-2bbac0274798	Art Director	7
9ec4301a-1522-4af9-b83b-92d50b4f0db9	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	8
9ec4301a-1522-4af9-b83b-92d50b4f0db9	9a0aefbe-591f-4dae-9c4d-5ff785c4a061	Editor	9
ce555690-494d-4983-a2a7-c99fb2fc0387	e20f479b-3a6a-47d7-96e3-e7e31e723e46	Director	-2
ce555690-494d-4983-a2a7-c99fb2fc0387	d136912d-c3cc-4246-a9cc-0752da39dfab	Special Effects Director	-1
ce555690-494d-4983-a2a7-c99fb2fc0387	a5e97a63-5c15-41ba-85c9-71f2c7af4f01	Producer	1
ce555690-494d-4983-a2a7-c99fb2fc0387	47e3892f-c0a6-45b7-bd5a-a964b7718a1d	Screenplay	3
ce555690-494d-4983-a2a7-c99fb2fc0387	b4496161-1678-4409-b9fd-da6ef674df01	Cinematography	4
ce555690-494d-4983-a2a7-c99fb2fc0387	23af9bb7-2ab0-4bff-a544-25a14711d8ec	Cinematography	5
ce555690-494d-4983-a2a7-c99fb2fc0387	a87ae5a4-cb4e-4605-aaaf-6ca63f38f892	Sound Recording	6
ce555690-494d-4983-a2a7-c99fb2fc0387	d458d15a-475f-44c5-874a-6f3b29839182	Lighting	7
ce555690-494d-4983-a2a7-c99fb2fc0387	615f098e-644e-4429-98d6-8334a8e8ddec	Lighting	8
ce555690-494d-4983-a2a7-c99fb2fc0387	f3aab2c2-4a3e-41b2-bdc7-787488acc1bc	Art Director	9
ce555690-494d-4983-a2a7-c99fb2fc0387	41004f90-bd9d-43ab-a5d4-d1d3f0b6f829	Art Director	10
ce555690-494d-4983-a2a7-c99fb2fc0387	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	11
ce555690-494d-4983-a2a7-c99fb2fc0387	b819de2f-4340-4a22-bedc-9c6bfc49548c	Editor	12
16789ef4-c05d-4f15-b09f-3bed5291655c	334edb75-cdf8-4c2f-b22f-7697030a7701	Director	-1
16789ef4-c05d-4f15-b09f-3bed5291655c	a5e97a63-5c15-41ba-85c9-71f2c7af4f01	Producer	1
16789ef4-c05d-4f15-b09f-3bed5291655c	f1a27fcf-fc61-4758-b3d7-dab10b1303e9	Screenplay	3
16789ef4-c05d-4f15-b09f-3bed5291655c	8f0d87f4-a164-4c5a-af72-3d85ba1449ee	Cinematography	4
16789ef4-c05d-4f15-b09f-3bed5291655c	3eb06002-3915-448e-a679-6fc538a995f1	Sound Recording	5
16789ef4-c05d-4f15-b09f-3bed5291655c	1c177c21-bbf9-4d93-9986-ec61102dbb87	Lighting	6
16789ef4-c05d-4f15-b09f-3bed5291655c	1ccef90e-d58d-4bbc-996a-08005f93cd9d	Art Director	7
16789ef4-c05d-4f15-b09f-3bed5291655c	5c532e64-32a4-4291-8b62-7ea8be62cc38	Music	8
16789ef4-c05d-4f15-b09f-3bed5291655c	09aaa976-2352-491d-b7d1-27bf5b0fd8c5	Editor	9
16789ef4-c05d-4f15-b09f-3bed5291655c	7887e636-a848-430c-8436-293b47151fd0	Special Effects Director	13
ff2cfc4e-76d6-4985-811f-834d4b7f5485	24f35657-5e36-479c-b16e-442878de6253	Director	-2
ff2cfc4e-76d6-4985-811f-834d4b7f5485	d136912d-c3cc-4246-a9cc-0752da39dfab	Special Effects Director	-1
ff2cfc4e-76d6-4985-811f-834d4b7f5485	a5e97a63-5c15-41ba-85c9-71f2c7af4f01	Producer	1
ff2cfc4e-76d6-4985-811f-834d4b7f5485	47e3892f-c0a6-45b7-bd5a-a964b7718a1d	Screenplay	3
ff2cfc4e-76d6-4985-811f-834d4b7f5485	23af9bb7-2ab0-4bff-a544-25a14711d8ec	Cinematography	4
ff2cfc4e-76d6-4985-811f-834d4b7f5485	cabe2a54-774e-49c9-83f9-d86daf442136	Cinematography	5
ff2cfc4e-76d6-4985-811f-834d4b7f5485	1d93ccc6-3f5f-4c5a-b933-76e890eb5adf	Sound Recording	6
ff2cfc4e-76d6-4985-811f-834d4b7f5485	615f098e-644e-4429-98d6-8334a8e8ddec	Lighting	7
ff2cfc4e-76d6-4985-811f-834d4b7f5485	d7d3674f-ff56-438a-af89-26cafa460c57	Lighting	8
ff2cfc4e-76d6-4985-811f-834d4b7f5485	38b37c37-ad76-4398-ac1a-2bbac0274798	Art Director	9
ff2cfc4e-76d6-4985-811f-834d4b7f5485	41004f90-bd9d-43ab-a5d4-d1d3f0b6f829	Art Director	10
ff2cfc4e-76d6-4985-811f-834d4b7f5485	64d0b412-18b4-495b-bf51-f8f59395c90b	Music	11
ff2cfc4e-76d6-4985-811f-834d4b7f5485	4b710372-cad8-4bf3-accb-59557dd8d8f3	Editor	12
89faa565-3c41-4d2d-b589-df8b13007a5e	4b3a7838-059f-4398-8211-fd57a16453c7	Director	-1
89faa565-3c41-4d2d-b589-df8b13007a5e	e3a5a656-330e-4f39-a068-228d6bcf1b87	Original Story	2
89faa565-3c41-4d2d-b589-df8b13007a5e	edf7cbdc-0c89-413c-bc52-ff7d7671aa7e	Screenplay	3
89faa565-3c41-4d2d-b589-df8b13007a5e	bee2d6b7-568f-4386-b380-2ebe35fdc297	Cinematography	5
89faa565-3c41-4d2d-b589-df8b13007a5e	d4374410-4d45-4928-9216-559cf8217068	Sound Recording	6
89faa565-3c41-4d2d-b589-df8b13007a5e	c4a052b1-6559-493f-b0bf-ee05ebefc6fe	Lighting	7
89faa565-3c41-4d2d-b589-df8b13007a5e	d516b368-3b08-4d2d-845e-c3f2ae37033d	Art Director	8
89faa565-3c41-4d2d-b589-df8b13007a5e	a63d1091-af4f-49a3-9520-a3eb2ff778d2	Music	9
89faa565-3c41-4d2d-b589-df8b13007a5e	2e1c0225-a5f5-4b38-86e5-2cc9b3d04d63	Editor	10
f47487ec-0730-46ae-9056-29fe675715b0	de047fb1-0bc8-4eaf-84f5-6b340342a5f3	Director	-1
f47487ec-0730-46ae-9056-29fe675715b0	aa570b58-916a-4e25-895f-5d6393826fad	Screenplay	3
f47487ec-0730-46ae-9056-29fe675715b0	99da4137-2150-4449-bc63-91c854d9a477	Cinematography	4
f47487ec-0730-46ae-9056-29fe675715b0	9497e236-3905-40b9-b5ee-453b96fc5d89	Lighting	5
f47487ec-0730-46ae-9056-29fe675715b0	2caacc76-1f58-43ec-867c-ea717b8db1fb	Sound Recording	6
f47487ec-0730-46ae-9056-29fe675715b0	73378725-9e35-4f1f-b522-08ea234ce1e5	Art Director	7
f47487ec-0730-46ae-9056-29fe675715b0	139d9d4e-57f3-4a85-bf1b-f72ebcf0b2c0	Music	8
f47487ec-0730-46ae-9056-29fe675715b0	96fdf693-30a4-4a4f-9df7-b038e2aeafeb	Editor	9
40ca591f-8493-4fad-9527-464e3501e1d2	7887e636-a848-430c-8436-293b47151fd0	Director	-1
40ca591f-8493-4fad-9527-464e3501e1d2	f3d54e06-5646-4d23-8b5e-8346da366ce3	Producer	1
40ca591f-8493-4fad-9527-464e3501e1d2	f1a27fcf-fc61-4758-b3d7-dab10b1303e9	Screenplay	3
40ca591f-8493-4fad-9527-464e3501e1d2	468ac861-fbe0-4d61-9c3f-1434781fe8fd	Cinematography	4
40ca591f-8493-4fad-9527-464e3501e1d2	3eb06002-3915-448e-a679-6fc538a995f1	Sound Recording	5
40ca591f-8493-4fad-9527-464e3501e1d2	9565e97a-5e0a-4ed8-8400-8e8e02e29a7b	Lighting	6
40ca591f-8493-4fad-9527-464e3501e1d2	b322f19f-bf67-4e2c-8a50-476de85f537b	Art Director	7
40ca591f-8493-4fad-9527-464e3501e1d2	09aaa976-2352-491d-b7d1-27bf5b0fd8c5	Editor	12
40ca591f-8493-4fad-9527-464e3501e1d2	1715410d-9cf0-4ecd-9857-4fb5f1bd4b97	Music	99
a50d9661-fed2-455d-9a9a-009ffa254b07	0d8bace7-0e59-4e11-946c-5f33f08f03f1	Director	-2
a50d9661-fed2-455d-9a9a-009ffa254b07	4e61a1bd-6487-45e6-a191-2c5700363891	Special Effects Director	-1
a50d9661-fed2-455d-9a9a-009ffa254b07	0ac5ec0b-66de-41d3-86b3-599bed0ed8c9	Producer	1
a50d9661-fed2-455d-9a9a-009ffa254b07	4139cd2f-a171-45dd-9606-0621de923045	Screenplay	3
a50d9661-fed2-455d-9a9a-009ffa254b07	8aaea7b8-c2c0-4204-a62f-f6e0594f286e	Screenplay	4
a50d9661-fed2-455d-9a9a-009ffa254b07	0d8bace7-0e59-4e11-946c-5f33f08f03f1	Screenplay	5
a50d9661-fed2-455d-9a9a-009ffa254b07	ac47d37c-4ba3-4920-8008-39bd496673f9	Cinematography	7
a50d9661-fed2-455d-9a9a-009ffa254b07	1e947044-87dd-4398-859a-4f20184f86c8	Cinematography	8
a50d9661-fed2-455d-9a9a-009ffa254b07	460ddeaf-4325-499f-aa2f-82e89782fe5d	Art Director	9
a50d9661-fed2-455d-9a9a-009ffa254b07	4dd7e01c-2b16-4fd3-b182-acea716de1cd	Music	10
a50d9661-fed2-455d-9a9a-009ffa254b07	35dd54c6-d61a-471e-a6ad-fc2b4b992219	Lighting	11
a50d9661-fed2-455d-9a9a-009ffa254b07	48184ea8-dffd-4f03-8f73-57f5ff3d94d4	Lighting	12
a50d9661-fed2-455d-9a9a-009ffa254b07	55575c38-b55e-4bb0-b308-e36b03307420	Editor	13
bbfd5e01-14bc-4890-aab1-92a02bec413d	7887e636-a848-430c-8436-293b47151fd0	Director	-1
bbfd5e01-14bc-4890-aab1-92a02bec413d	f3d54e06-5646-4d23-8b5e-8346da366ce3	Producer	1
bbfd5e01-14bc-4890-aab1-92a02bec413d	f1a27fcf-fc61-4758-b3d7-dab10b1303e9	Screenplay	4
bbfd5e01-14bc-4890-aab1-92a02bec413d	e01927e9-11a5-46a9-a060-baba807daf43	Cinematography	5
bbfd5e01-14bc-4890-aab1-92a02bec413d	ccf80df2-a664-4ca3-ad2c-b682ef456b3b	Sound Recording	7
bbfd5e01-14bc-4890-aab1-92a02bec413d	1efc7ab0-558e-40d5-9ff6-e7d469357984	Lighting	8
bbfd5e01-14bc-4890-aab1-92a02bec413d	528d732d-4d4c-430f-92a0-07de1e0b311d	Art Director	9
bbfd5e01-14bc-4890-aab1-92a02bec413d	ddcab35a-da50-4f15-8055-eef5b564db80	Music	10
bbfd5e01-14bc-4890-aab1-92a02bec413d	351512e7-428a-47ea-bb92-a234d14376af	Editor	15
ef01babe-d621-40ca-8d85-363b051921a6	0d8bace7-0e59-4e11-946c-5f33f08f03f1	Director	-1
ef01babe-d621-40ca-8d85-363b051921a6	d06885ec-080f-49eb-9bd7-dd119fd1086c	Producer	1
ef01babe-d621-40ca-8d85-363b051921a6	edf7cbdc-0c89-413c-bc52-ff7d7671aa7e	Screenplay	3
ef01babe-d621-40ca-8d85-363b051921a6	ac47d37c-4ba3-4920-8008-39bd496673f9	Cinematography	4
ef01babe-d621-40ca-8d85-363b051921a6	b86bdf63-3b93-45b4-9fac-e502ae05c8dc	Cinematography	5
ef01babe-d621-40ca-8d85-363b051921a6	a63d1091-af4f-49a3-9520-a3eb2ff778d2	Music	7
ef01babe-d621-40ca-8d85-363b051921a6	bdf1596b-70f1-4d02-a4a7-47da0f31eee2	Lighting	8
ef01babe-d621-40ca-8d85-363b051921a6	4282aa50-5c6f-411f-8293-36d2798949d7	Editor	9
0b006dae-79e5-4dca-b8e2-09591eacba55	4b3a7838-059f-4398-8211-fd57a16453c7	Director	-1
0b006dae-79e5-4dca-b8e2-09591eacba55	89bb92ec-906d-4ae8-8296-1c917f0224b1	Producer	1
0b006dae-79e5-4dca-b8e2-09591eacba55	edf7cbdc-0c89-413c-bc52-ff7d7671aa7e	Screenplay	2
0b006dae-79e5-4dca-b8e2-09591eacba55	ef20d0c1-0371-4c88-91ec-a7b71b625ba8	Screenplay	3
0b006dae-79e5-4dca-b8e2-09591eacba55	ac47d37c-4ba3-4920-8008-39bd496673f9	Cinematography	4
0b006dae-79e5-4dca-b8e2-09591eacba55	094fbabe-38ec-4b55-a2a9-eaf5d712716b	Art Director	5
0b006dae-79e5-4dca-b8e2-09591eacba55	a63d1091-af4f-49a3-9520-a3eb2ff778d2	Music	6
0b006dae-79e5-4dca-b8e2-09591eacba55	bdf1596b-70f1-4d02-a4a7-47da0f31eee2	Lighting	7
0b006dae-79e5-4dca-b8e2-09591eacba55	4282aa50-5c6f-411f-8293-36d2798949d7	Editor	8
0b006dae-79e5-4dca-b8e2-09591eacba55	0e124ef1-d5e9-4473-8dad-ca7833fccb33	Sound Recording	9
b093530b-88fa-4439-bce1-aaf1b066b5ba	a49b90b1-3cb5-44ec-89d0-12da68234600	Director	-1
b093530b-88fa-4439-bce1-aaf1b066b5ba	89bb92ec-906d-4ae8-8296-1c917f0224b1	Producer	1
b093530b-88fa-4439-bce1-aaf1b066b5ba	22e872ab-b41f-48d0-a34d-f4e1987fade3	Screenplay	2
b093530b-88fa-4439-bce1-aaf1b066b5ba	ef20d0c1-0371-4c88-91ec-a7b71b625ba8	Screenplay	3
b093530b-88fa-4439-bce1-aaf1b066b5ba	395dcc9b-eee7-4108-9821-b298a36c3763	Cinematography	4
b093530b-88fa-4439-bce1-aaf1b066b5ba	0acf9ae6-3158-4cba-8218-1c29e2db28fb	Cinematography	5
b093530b-88fa-4439-bce1-aaf1b066b5ba	ff95dbdf-9c88-49ba-b744-67991d1f73cf	Art Director	6
b093530b-88fa-4439-bce1-aaf1b066b5ba	7c84b99f-8441-4bca-b272-28871206e3c8	Music	7
b093530b-88fa-4439-bce1-aaf1b066b5ba	c5ae1c5e-6885-484b-a6bc-7d86ec7d4559	Lighting	8
b093530b-88fa-4439-bce1-aaf1b066b5ba	2e2c8b9c-e622-4534-8196-2cd54cf9d3d5	Editor	9
b093530b-88fa-4439-bce1-aaf1b066b5ba	5e025577-ff1e-4462-9c3d-0446693fe1cd	Sound Recording	10
9883d93a-db06-4c02-ba91-1d41c335acf1	449ff18f-f1bf-4f74-b7d0-d725027fa078	Director	-1
9883d93a-db06-4c02-ba91-1d41c335acf1	50fd1eb9-7289-4cf4-bdc6-065797936bd7	Original Story	3
9883d93a-db06-4c02-ba91-1d41c335acf1	449ff18f-f1bf-4f74-b7d0-d725027fa078	Screenplay	4
9883d93a-db06-4c02-ba91-1d41c335acf1	2209b83b-f80d-4f9b-be22-838581803d4b	Screenplay	5
9883d93a-db06-4c02-ba91-1d41c335acf1	786ceebd-6927-4242-a1cd-5933186090c3	Cinematography	6
9883d93a-db06-4c02-ba91-1d41c335acf1	a87ae5a4-cb4e-4605-aaaf-6ca63f38f892	Sound Recording	7
9883d93a-db06-4c02-ba91-1d41c335acf1	4c0538b4-3e0f-41ab-b29a-cf058f7f0708	Art Director	8
9883d93a-db06-4c02-ba91-1d41c335acf1	cbf78cce-3676-40c9-b871-0dcddd5423df	Music	9
9883d93a-db06-4c02-ba91-1d41c335acf1	fafb356d-5415-434e-9809-afd08177a68d	Lighting	10
9883d93a-db06-4c02-ba91-1d41c335acf1	e1099923-73b2-4388-8718-0bbeb2b38fe3	Editor	11
14fab775-bb0f-413e-9840-be528e07ba70	7991849b-aa0b-4efd-9759-dcc4ff87ceb1	Director	-1
14fab775-bb0f-413e-9840-be528e07ba70	c004779d-f965-4224-bb76-1f81f0a49f3b	Original Story	1
14fab775-bb0f-413e-9840-be528e07ba70	a0960493-3319-412c-afa8-1379f398b03e	Dramatization	3
14fab775-bb0f-413e-9840-be528e07ba70	f0551015-29c5-4b37-8b5c-298ee971ea76	Screenplay	4
14fab775-bb0f-413e-9840-be528e07ba70	7991849b-aa0b-4efd-9759-dcc4ff87ceb1	Screenplay	5
14fab775-bb0f-413e-9840-be528e07ba70	ffe848b7-80ec-4d5b-ba89-e1fc757c92d0	Cinematography	6
14fab775-bb0f-413e-9840-be528e07ba70	a37d0291-2e69-40af-86f0-133859aaf1ff	Art Director	7
14fab775-bb0f-413e-9840-be528e07ba70	24651b22-cbb0-4472-9d73-c96ed96829d6	Sound Recording	9
14fab775-bb0f-413e-9840-be528e07ba70	e4fc3ee2-b54f-4ec0-8a84-64352507c5de	Lighting	10
14fab775-bb0f-413e-9840-be528e07ba70	60c38e10-e1ed-46f5-b167-2938649e4503	Music	11
14fab775-bb0f-413e-9840-be528e07ba70	890b42f6-f12a-4afb-8b82-e1f37a6b4dc9	Assistant Director	12
14fab775-bb0f-413e-9840-be528e07ba70	d9450e7b-d3e4-4def-9922-8896ebfa3ae6	Editor	13
6c45cc47-8f6d-4861-95ab-4c9a2b404218	7991849b-aa0b-4efd-9759-dcc4ff87ceb1	Director	-1
6c45cc47-8f6d-4861-95ab-4c9a2b404218	c004779d-f965-4224-bb76-1f81f0a49f3b	Original Story	2
6c45cc47-8f6d-4861-95ab-4c9a2b404218	a0960493-3319-412c-afa8-1379f398b03e	Dramatization	3
6c45cc47-8f6d-4861-95ab-4c9a2b404218	f0551015-29c5-4b37-8b5c-298ee971ea76	Screenplay	4
6c45cc47-8f6d-4861-95ab-4c9a2b404218	7991849b-aa0b-4efd-9759-dcc4ff87ceb1	Screenplay	5
6c45cc47-8f6d-4861-95ab-4c9a2b404218	ffe848b7-80ec-4d5b-ba89-e1fc757c92d0	Cinematography	6
6c45cc47-8f6d-4861-95ab-4c9a2b404218	a37d0291-2e69-40af-86f0-133859aaf1ff	Art Director	7
6c45cc47-8f6d-4861-95ab-4c9a2b404218	24651b22-cbb0-4472-9d73-c96ed96829d6	Sound Recording	9
6c45cc47-8f6d-4861-95ab-4c9a2b404218	e4fc3ee2-b54f-4ec0-8a84-64352507c5de	Lighting	10
6c45cc47-8f6d-4861-95ab-4c9a2b404218	60c38e10-e1ed-46f5-b167-2938649e4503	Music	11
6c45cc47-8f6d-4861-95ab-4c9a2b404218	890b42f6-f12a-4afb-8b82-e1f37a6b4dc9	Assistant Director	14
6c45cc47-8f6d-4861-95ab-4c9a2b404218	d9450e7b-d3e4-4def-9922-8896ebfa3ae6	Editor	15
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	7991849b-aa0b-4efd-9759-dcc4ff87ceb1	Director	-1
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	c004779d-f965-4224-bb76-1f81f0a49f3b	Original Story	2
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	a0960493-3319-412c-afa8-1379f398b03e	Dramatization	3
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	f0551015-29c5-4b37-8b5c-298ee971ea76	Screenplay	4
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	7991849b-aa0b-4efd-9759-dcc4ff87ceb1	Screenplay	5
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	3df58f3a-039b-45ab-bf42-d842796cb7fe	Cinematography	6
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	a37d0291-2e69-40af-86f0-133859aaf1ff	Art Director	7
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	177089db-5eef-4ab2-8d7a-cf11693545ca	Sound Recording	9
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	b4a497d1-74e0-4304-bc20-7a32275c73ab	Lighting	10
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	60c38e10-e1ed-46f5-b167-2938649e4503	Music	11
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	890b42f6-f12a-4afb-8b82-e1f37a6b4dc9	Assistant Director	12
8196e3f6-20f4-44a6-ab7c-d58dbedc4475	d1e73155-2bf5-4378-929f-277d92e5e2ae	Editor	13
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	449ff18f-f1bf-4f74-b7d0-d725027fa078	Director	-1
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	fe66f8e5-725a-4936-ac68-57c5c4d8083f	Producer	1
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	449ff18f-f1bf-4f74-b7d0-d725027fa078	Screenplay	2
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	2209b83b-f80d-4f9b-be22-838581803d4b	Screenplay	3
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	b54ca5c3-b7bf-4ad3-a3eb-8b30339ffa54	Screenplay	4
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	dcf535d9-0eeb-4d33-9323-6c9a5222056e	Cinematography	5
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	4c0538b4-3e0f-41ab-b29a-cf058f7f0708	Art Director	6
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	e4fc3ee2-b54f-4ec0-8a84-64352507c5de	Lighting	7
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	8fbf0eb6-d46a-4f69-94ca-c3bfaf6b5e07	Sound Recording	8
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	cbf78cce-3676-40c9-b871-0dcddd5423df	Music	9
483afdf4-329f-42fb-8d0c-a1d7bd60d5d2	d1e73155-2bf5-4378-929f-277d92e5e2ae	Editor	99
0541315f-20ef-4562-95a5-8c4f45199d63	449ff18f-f1bf-4f74-b7d0-d725027fa078	Director	-1
0541315f-20ef-4562-95a5-8c4f45199d63	449ff18f-f1bf-4f74-b7d0-d725027fa078	Producer	1
0541315f-20ef-4562-95a5-8c4f45199d63	fe66f8e5-725a-4936-ac68-57c5c4d8083f	Producer	2
0541315f-20ef-4562-95a5-8c4f45199d63	b54ca5c3-b7bf-4ad3-a3eb-8b30339ffa54	Screenplay	3
0541315f-20ef-4562-95a5-8c4f45199d63	2209b83b-f80d-4f9b-be22-838581803d4b	Screenplay	4
0541315f-20ef-4562-95a5-8c4f45199d63	9da86934-7584-466a-84be-853819168103	Screenplay	5
0541315f-20ef-4562-95a5-8c4f45199d63	449ff18f-f1bf-4f74-b7d0-d725027fa078	Screenplay	6
0541315f-20ef-4562-95a5-8c4f45199d63	dcf535d9-0eeb-4d33-9323-6c9a5222056e	Cinematography	7
0541315f-20ef-4562-95a5-8c4f45199d63	0c5b7ba3-0ddb-4948-92e3-5f18d542e397	Art Director	8
0541315f-20ef-4562-95a5-8c4f45199d63	986d08ab-500a-4b71-a4e6-5cb2bcf6abb4	Lighting	10
0541315f-20ef-4562-95a5-8c4f45199d63	8fbf0eb6-d46a-4f69-94ca-c3bfaf6b5e07	Sound Recording	9
0541315f-20ef-4562-95a5-8c4f45199d63	54122b4f-936f-47e5-a637-3ba3d24763b9	Music	12
\.


--
-- Data for Name: studio_films; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY studio_films (studio_id, film_id) FROM stdin;
b52fcdd6-691b-4a16-a670-e6ad6f176521	653335e2-101e-4303-90a2-eb71dac3c6e3
b52fcdd6-691b-4a16-a670-e6ad6f176521	79a16ff9-c72a-4dd0-ba4e-67f578e97682
b52fcdd6-691b-4a16-a670-e6ad6f176521	7f9c68a7-8cec-4f4e-be97-528fe66605c3
b52fcdd6-691b-4a16-a670-e6ad6f176521	56dab76c-fc4d-4547-b2fe-3a743154f1d5
b52fcdd6-691b-4a16-a670-e6ad6f176521	ef4f2354-b764-4f5e-af66-813369a2520c
b52fcdd6-691b-4a16-a670-e6ad6f176521	132ec70b-0248-450e-9ae2-38c8245dc2e9
b52fcdd6-691b-4a16-a670-e6ad6f176521	dbf96f34-252e-4cbb-bc3d-e7f74e8abea9
b52fcdd6-691b-4a16-a670-e6ad6f176521	0a158e9d-6e48-4b6e-9674-862d952fb3ab
b52fcdd6-691b-4a16-a670-e6ad6f176521	b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09
b52fcdd6-691b-4a16-a670-e6ad6f176521	249785ea-a53b-43e3-94d6-c5d2f2d833c4
b52fcdd6-691b-4a16-a670-e6ad6f176521	e8ccb201-e076-48cb-9307-f8b99101f133
b52fcdd6-691b-4a16-a670-e6ad6f176521	a62c9a6b-aa36-4d5d-b869-2fc79efa28ab
b52fcdd6-691b-4a16-a670-e6ad6f176521	9b724e83-39e6-4e57-b112-81e74d578ae0
b52fcdd6-691b-4a16-a670-e6ad6f176521	80731aaf-e8e4-4c5b-bd80-e033bd3a7daa
b52fcdd6-691b-4a16-a670-e6ad6f176521	d6a05fe9-ea91-4b75-a04a-77c8217a56cd
b52fcdd6-691b-4a16-a670-e6ad6f176521	7df339b8-5cc8-4cfc-87a7-d8012c2a9916
b52fcdd6-691b-4a16-a670-e6ad6f176521	b30c5657-a980-489b-bd91-d58e63609102
b52fcdd6-691b-4a16-a670-e6ad6f176521	5df297a2-5f6d-430d-b7fc-952e97ac9d79
b52fcdd6-691b-4a16-a670-e6ad6f176521	75bb901c-e41c-494f-aae8-7a5282f3bf96
b52fcdd6-691b-4a16-a670-e6ad6f176521	700c2ce1-095e-48ac-96c0-1d31f0c4e52b
b52fcdd6-691b-4a16-a670-e6ad6f176521	2f761ce5-34ae-4e7e-8ce0-90fec7f94f68
b52fcdd6-691b-4a16-a670-e6ad6f176521	183fbe01-1bd2-4ade-b83b-6248ec7d7fee
b52fcdd6-691b-4a16-a670-e6ad6f176521	0a2401ee-c5da-4e00-a2bc-d6ae7026aa13
b52fcdd6-691b-4a16-a670-e6ad6f176521	23c1c82e-aedb-4c9b-b040-c780eec577e8
b52fcdd6-691b-4a16-a670-e6ad6f176521	f474852a-cc25-477d-a7b9-06aa688f7fb2
b52fcdd6-691b-4a16-a670-e6ad6f176521	3b0b0351-0b4b-4ab1-a84e-6fc554c86a31
b52fcdd6-691b-4a16-a670-e6ad6f176521	ba6031ef-c7b0-451c-8465-cb2a3c494896
b52fcdd6-691b-4a16-a670-e6ad6f176521	40cb6fad-15b4-46f5-8066-273cb965c3c4
b52fcdd6-691b-4a16-a670-e6ad6f176521	7be35dd2-8758-4cb8-85af-17985772d431
a7136259-307b-4315-9247-4bd6ee60ae61	3b0b0351-0b4b-4ab1-a84e-6fc554c86a31
c21957cc-cf69-4391-86f7-76e151b5ba73	0704c7e5-5709-4401-adaa-8cbec670e47d
c21957cc-cf69-4391-86f7-76e151b5ba73	16789ef4-c05d-4f15-b09f-3bed5291655c
c21957cc-cf69-4391-86f7-76e151b5ba73	40ca591f-8493-4fad-9527-464e3501e1d2
c21957cc-cf69-4391-86f7-76e151b5ba73	bbfd5e01-14bc-4890-aab1-92a02bec413d
c21957cc-cf69-4391-86f7-76e151b5ba73	9ec4301a-1522-4af9-b83b-92d50b4f0db9
c21957cc-cf69-4391-86f7-76e151b5ba73	ff2cfc4e-76d6-4985-811f-834d4b7f5485
c21957cc-cf69-4391-86f7-76e151b5ba73	ce555690-494d-4983-a2a7-c99fb2fc0387
c21957cc-cf69-4391-86f7-76e151b5ba73	7c83d9c1-2c56-4a75-874b-5ee2f80f4bb8
be46d083-e66d-4292-86fa-b1e26d4f5eed	0b006dae-79e5-4dca-b8e2-09591eacba55
be46d083-e66d-4292-86fa-b1e26d4f5eed	b093530b-88fa-4439-bce1-aaf1b066b5ba
be46d083-e66d-4292-86fa-b1e26d4f5eed	a50d9661-fed2-455d-9a9a-009ffa254b07
be46d083-e66d-4292-86fa-b1e26d4f5eed	ef01babe-d621-40ca-8d85-363b051921a6
95ad9c89-93ff-4636-8cb7-4ce98b441801	f47487ec-0730-46ae-9056-29fe675715b0
95ad9c89-93ff-4636-8cb7-4ce98b441801	89faa565-3c41-4d2d-b589-df8b13007a5e
c21957cc-cf69-4391-86f7-76e151b5ba73	9883d93a-db06-4c02-ba91-1d41c335acf1
b52fcdd6-691b-4a16-a670-e6ad6f176521	14fab775-bb0f-413e-9840-be528e07ba70
b52fcdd6-691b-4a16-a670-e6ad6f176521	6c45cc47-8f6d-4861-95ab-4c9a2b404218
b52fcdd6-691b-4a16-a670-e6ad6f176521	8196e3f6-20f4-44a6-ab7c-d58dbedc4475
b52fcdd6-691b-4a16-a670-e6ad6f176521	483afdf4-329f-42fb-8d0c-a1d7bd60d5d2
b52fcdd6-691b-4a16-a670-e6ad6f176521	0541315f-20ef-4562-95a5-8c4f45199d63
\.


--
-- Data for Name: studios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY studios (id, name) FROM stdin;
b52fcdd6-691b-4a16-a670-e6ad6f176521	Toho
a7136259-307b-4315-9247-4bd6ee60ae61	Mifune Productions
c21957cc-cf69-4391-86f7-76e151b5ba73	Daiei
be46d083-e66d-4292-86fa-b1e26d4f5eed	Shochiku
95ad9c89-93ff-4636-8cb7-4ce98b441801	Toei
\.


--
-- Name: film_images film_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY film_images
    ADD CONSTRAINT film_images_pkey PRIMARY KEY (type, file_name, film_id);


--
-- Name: films films_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY films
    ADD CONSTRAINT films_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: studios studios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY studios
    ADD CONSTRAINT studios_pkey PRIMARY KEY (id);


--
-- Name: actor_group_roles actor_group_roles_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY actor_group_roles
    ADD CONSTRAINT actor_group_roles_film_id_fkey FOREIGN KEY (film_id) REFERENCES films(id);


--
-- Name: actor_group_roles actor_group_roles_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY actor_group_roles
    ADD CONSTRAINT actor_group_roles_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id);


--
-- Name: actor_person_roles actor_person_roles_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY actor_person_roles
    ADD CONSTRAINT actor_person_roles_film_id_fkey FOREIGN KEY (film_id) REFERENCES films(id);


--
-- Name: actor_person_roles actor_person_roles_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY actor_person_roles
    ADD CONSTRAINT actor_person_roles_person_id_fkey FOREIGN KEY (person_id) REFERENCES people(id);


--
-- Name: film_images film_images_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY film_images
    ADD CONSTRAINT film_images_film_id_fkey FOREIGN KEY (film_id) REFERENCES films(id);


--
-- Name: group_memberships group_memberships_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_memberships
    ADD CONSTRAINT group_memberships_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id);


--
-- Name: group_memberships group_memberships_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_memberships
    ADD CONSTRAINT group_memberships_person_id_fkey FOREIGN KEY (person_id) REFERENCES people(id);


--
-- Name: series_films series_films_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY series_films
    ADD CONSTRAINT series_films_film_id_fkey FOREIGN KEY (film_id) REFERENCES films(id);


--
-- Name: series_films series_films_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY series_films
    ADD CONSTRAINT series_films_series_id_fkey FOREIGN KEY (series_id) REFERENCES series(id);


--
-- Name: staff_person_roles staff_person_roles_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY staff_person_roles
    ADD CONSTRAINT staff_person_roles_film_id_fkey FOREIGN KEY (film_id) REFERENCES films(id);


--
-- Name: staff_person_roles staff_person_roles_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY staff_person_roles
    ADD CONSTRAINT staff_person_roles_person_id_fkey FOREIGN KEY (person_id) REFERENCES people(id);


--
-- Name: studio_films studio_films_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY studio_films
    ADD CONSTRAINT studio_films_film_id_fkey FOREIGN KEY (film_id) REFERENCES films(id);


--
-- Name: studio_films studio_films_studio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY studio_films
    ADD CONSTRAINT studio_films_studio_id_fkey FOREIGN KEY (studio_id) REFERENCES studios(id);


--
-- PostgreSQL database dump complete
--

