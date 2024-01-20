plx_Detailed_Production_History

-- public.keys definition

-- Drop table

-- DROP TABLE public.keys;

CREATE TABLE public.keys (
	rfingerprint text NOT NULL,
	doc jsonb NOT NULL,
	ctime timestamptz NOT NULL,
	mtime timestamptz NOT NULL,
	md5 text NOT NULL,
	keywords tsvector NULL,
	CONSTRAINT keys_md5_key UNIQUE (md5),
	CONSTRAINT keys_pkey PRIMARY KEY (rfingerprint)
);
CREATE INDEX keys_ctime ON public.keys USING btree (ctime);
CREATE INDEX keys_keywords ON public.keys USING gin (keywords);
CREATE INDEX keys_mtime ON public.keys USING btree (mtime);
CREATE INDEX keys_rfp ON public.keys USING btree (rfingerprint text_pattern_ops);