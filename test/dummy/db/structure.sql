--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: cards_cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cards_cards (
    id integer NOT NULL,
    suit smallint NOT NULL,
    rank character varying(15) NOT NULL,
    pic character varying(10) DEFAULT '0'::character varying NOT NULL
);


--
-- Name: cards_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cards_cards_id_seq OWNED BY cards_cards.id;


--
-- Name: cards_game_cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cards_game_cards (
    id integer NOT NULL,
    game_id integer,
    card_id integer,
    isopen smallint DEFAULT 0 NOT NULL,
    pos smallint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cards_game_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_game_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards_game_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cards_game_cards_id_seq OWNED BY cards_game_cards.id;


--
-- Name: cards_game_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cards_game_users (
    id integer NOT NULL,
    game_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cards_game_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_game_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards_game_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cards_game_users_id_seq OWNED BY cards_game_users.id;


--
-- Name: cards_games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cards_games (
    id integer NOT NULL,
    gamekey character varying(50),
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cards_games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards_games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cards_games_id_seq OWNED BY cards_games.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(50),
    ip character varying(32) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards_cards ALTER COLUMN id SET DEFAULT nextval('cards_cards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards_game_cards ALTER COLUMN id SET DEFAULT nextval('cards_game_cards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards_game_users ALTER COLUMN id SET DEFAULT nextval('cards_game_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards_games ALTER COLUMN id SET DEFAULT nextval('cards_games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: cards_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cards_cards
    ADD CONSTRAINT cards_cards_pkey PRIMARY KEY (id);


--
-- Name: cards_game_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cards_game_cards
    ADD CONSTRAINT cards_game_cards_pkey PRIMARY KEY (id);


--
-- Name: cards_game_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cards_game_users
    ADD CONSTRAINT cards_game_users_pkey PRIMARY KEY (id);


--
-- Name: cards_games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cards_games
    ADD CONSTRAINT cards_games_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX game_id ON cards_game_users USING btree (game_id);


--
-- Name: index_cards_cards_on_pic; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cards_cards_on_pic ON cards_cards USING btree (pic);


--
-- Name: index_cards_cards_on_rank; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cards_cards_on_rank ON cards_cards USING btree (rank);


--
-- Name: index_cards_game_cards_on_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cards_game_cards_on_card_id ON cards_game_cards USING btree (card_id);


--
-- Name: index_cards_game_cards_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cards_game_cards_on_game_id ON cards_game_cards USING btree (game_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_id ON cards_game_users USING btree (user_id);


--
-- Name: fk_game_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards_game_users
    ADD CONSTRAINT fk_game_id FOREIGN KEY (game_id) REFERENCES cards_games(id);


--
-- Name: fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards_games
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards_game_users
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130610035707');

INSERT INTO schema_migrations (version) VALUES ('20130610044217');

INSERT INTO schema_migrations (version) VALUES ('20130611224725');

INSERT INTO schema_migrations (version) VALUES ('20130612005031');

INSERT INTO schema_migrations (version) VALUES ('20130612185623');