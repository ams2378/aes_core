class c_20_1;
    integer ld_density = 100;
    integer status = 1;
    rand bit[0:0] ld; // rand_mode = ON 

    constraint density_dist_this    // (constraint_mode = ON) (../bench/test.sv:19)
    {
       (ld dist {0 :/ (100 - ld_density), 1 :/ ld_density});
    }
    constraint ld_status_this    // (constraint_mode = ON) (../bench/test.sv:24)
    {
       (status != 0) -> (ld == 1'h0);
    }
endclass

program p_20_1;
    c_20_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "100x00x1x0z101xx11x0xz1xzz111110xxzxzxzxzzzzzzxxxzxzxxxxxzxxxxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
