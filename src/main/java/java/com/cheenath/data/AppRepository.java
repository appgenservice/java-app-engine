package com.cheenath.data;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.math.BigDecimal;

public interface AppRepository extends CrudRepository<App, Long> {

	App findById(long id);

	@Query(value = "select max(a.id) from app a")
	BigDecimal findMaxAppId();
}
