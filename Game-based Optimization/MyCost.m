function z = MyCost(x, Cuo, Cup, coeff)
        
    % Game Constraints
    R = x(4) * ((coeff(1) * (Cuo(1) + x(1))) + ((coeff(2) * (Cuo(2) - x(2))) + (coeff(3) * (Cuo(3) + x(3)))));
    S = (coeff(1) * Cup(1) + coeff(3) * Cup(3)) + (coeff(2) * Cuo(2));
    T = (coeff(1) * Cuo(1) + coeff(3) * Cuo(3)) + (coeff(2) * Cup(2));
    P = x(5) * ((coeff(1) * (Cuo(1) + x(1))) + ((coeff(2) * (Cuo(2) - x(2))) + (coeff(3) * (Cuo(3) + x(3)))));

    % Game's Violations
    Violation1 = max(0, R);
    Violation2 = max(0, S);
    Violation3 = max(0, T);
    Violation4 = max(0, P);

    % Game alpha
    R_U = 200;
    S_U = 900;
    T_U = 18000;
    P_U = 30;

    % Updated Rho
    R_U = R + R_U * Violation1;
    S_U = S + S_U * Violation2;
    T_U = T + T_U * Violation3;
    P_U = P + P_U * Violation4;

    % First PD constraint
    ViolationPD1 = max(0, (2 * R_U) - S_U - T_U);
    PD1 = (2 * R_U) - S_U - T_U + 500 * ViolationPD1;

    % Second PD constraint
    ViolationPD2 = max(0, T_U - R_U);
    PD2 = T_U - R_U + 200 * ViolationPD2;

    ViolationPD3 = max(0, R_U - P_U);
    PD3 = R_U - P_U + 200 * ViolationPD3;

    ViolationPD4 = max(0, P_U - S_U);
    PD4 = P_U - S_U + 200 * ViolationPD4;
    
    alpha = 100;
    
    % Distance Objective Funtion
    % Increasing
    Violationz1 = max(0, (x(2)/Cup(2)-Cuo(2))-1);
    z1 = abs(Cuo(2) + x(2) - Cup(2)) + (alpha * Violationz1) + (alpha * Violation1) + (alpha * Violation2) + (alpha * Violation3) + (alpha * Violation4);
    % Decreasing
    Violationz2 = max(0, (x(1)/Cup(1)-Cuo(1))-1);
    z2 = abs(Cuo(1) - x(1) - Cup(1)) + (alpha * Violationz2) + (alpha * Violation1) + (alpha * Violation2) + (alpha * Violation3) + (alpha * Violation4);
    % Increasing
    Violationz3 = max(0, (x(3)/Cup(3)-Cuo(3))-1);
    z3 = abs(Cuo(3) + x(3) - Cup(3)) + (alpha * Violationz3) + (alpha * Violation1) + (alpha * Violation2) + (alpha * Violation3) + (alpha * Violation4);
    
    % Objective Functions
    z = [z1; z2; z3; R_U; S_U; T_U; P_U; PD1; PD2; PD3; PD4];

end