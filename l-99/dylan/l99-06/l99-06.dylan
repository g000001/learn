module: l99-06

define generic palindrome? 
    (sequence :: <sequence>)
 => (result :: <boolean>);

define method palindrome?
    (sequence :: <sequence>)
 => (result :: <boolean>)
  (sequence = sequence.reverse)
end method palindrome?;


// define method palindrome?
//     (sequence :: <sequence>)
//  => (result :: <boolean>)
//   if (sequence = sequence.reverse)
//     #t
//   else
//     #f
//   end if
// end method;


let lst = #(x:, a:, m:, a:, x:);
let str = "xamax";
let vec = #[x:, a:, m:, a:, x:, a:];
//format-out("%= %=\n", lst, palindrome?(lst));
//format-out("%= %=\n", str, palindrome?(str));
//format-out("%= %=\n", vec, palindrome?(vec));

//format-out("%= \n",#(lst, str, vec));

do (method (x) format-out("%= => %=\n", x, x.palindrome?) end,
    list(lst, str, vec));

//#(#"x", #"a", #"m", #"a", #"x") => #t
//"xamax" => #t
//#[#"x", #"a", #"m", #"a", #"x", #"a"] => #f
      


