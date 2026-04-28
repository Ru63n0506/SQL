DELIMITER // 
CREATE TRIGGER actualizar_stock_surte AFTER INSERT ON surte 
FOR EACH ROW 
BEGIN 
UPDATE medicamento SET cantidad = cantidad + NEW.cantidad WHERE id = NEW.id_medicamento; 
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER modifMedicamento AFTER INSERT ON recetar
FOR EACH ROW
BEGIN
UPDATE medicamento
SET cantidad = cantidad - NEW.cantidad
WHERE id = NEW.id_medicamento;
END //
DELIMITER ;
