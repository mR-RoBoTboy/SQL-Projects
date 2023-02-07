CREATE OR REPLACE FUNCTION public.all_prime(INT4, INT4)
RETURNS TEXT AS

$BODY$
DECLARE 
  v_start		ALIAS FOR $1;
  v_end			ALIAS FOR $2;
  v_test		INT4;
  v_divisor		INT4;
  v_prime_list	TEXT DEFAULT 0;
  v_msg			TEXT;
BEGIN
	v_test = v_start;
		WHILE (v_test <= v_end) LOOP
	v_divisor = 2;
		WHILE (v_divisor <= v_test) LOOP
			IF mod(v_test, v_divisor) = 0 AND v_divisor <v_test THEN
				EXIT;
			ELSE 
				IF mod(v_test, v_divisor) = 0 AND v_divisor = v_test THEN
                       IF v_prime_list > '' THEN
						v_prime_list =v_prime_list ||  ',';
					END IF;
                  v_prime_list = v_prime_list ||v_test::text;
				END IF;
			END IF;
			v_divisor = v_divisor +1;
		END LOOP;
		v_test = v_test + 1;
	END LOOP;
	RETURN v_prime_list;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



GRANT EXECUTE ON FUNCTION public.all_prime(INT4, INT4) TO public;
COMMENT ON FUNCTION public.all_prime(INT4, INT4) IS 'Returns list of all
prime numbers from $1 to $2';
========================================================================
==========

select all_prime(25,50);